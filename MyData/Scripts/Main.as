Scene@ scene_;
Node@ cameraNode;
float cameraYaw;
float cameraPitch;

void Start()
{
    renderer.shadowMapSize = 2048;
    renderer.shadowQuality = SHADOWQUALITY_PCF_16BIT;

    scene_ = Scene();
    scene_.CreateComponent("Octree");
    
    Node@ zoneNode = scene_.CreateChild();
    Zone@ zone = zoneNode.CreateComponent("Zone");
    zone.boundingBox = BoundingBox(-1000.0f, 1000.0f);
    zone.ambientColor = Color(0.4f, 0.4f, 0.4f);
    zone.fogColor = Color(1.0f, 1.0f, 1.0f);
    zone.fogStart = 0.0f;
    zone.fogEnd = 300.0f;

    Node@ lightNode = scene_.CreateChild();
    lightNode.direction = Vector3(0.6f, -0.6f, 0.8f);
    Light@ light = lightNode.CreateComponent("Light");
    light.lightType = LIGHT_DIRECTIONAL;
    light.color = Color(0.6f, 0.6f, 0.6f);
    light.castShadows = true;
    light.shadowCascade = CascadeParameters(10.0f, 20.0f, 30.0f, 40.0f, 0.8f);
    light.shadowBias = BiasParameters(0.0f, 0.01f, 0.01f);
    
    cameraNode = scene_.CreateChild();
    cameraNode.position = Vector3(-2.0f, 2.0f, -5.0f);
    cameraNode.LookAt(Vector3(0.0f, 1.0f, 0.0f));
    cameraYaw = cameraNode.rotation.yaw;
    cameraPitch = cameraNode.rotation.pitch;
    cameraNode.CreateComponent("Camera");

    Node@ groundNode = scene_.CreateChild();
    groundNode.scale = Vector3(100.0f, 1.0f, 100.0f);
    StaticModel@ groundObject = groundNode.CreateComponent("StaticModel");
    groundObject.model = cache.GetResource("Model", "Models/Plane.mdl");
    groundObject.material = cache.GetResource("Material", "Materials/Ground.xml");

    Node@ wallNode = scene_.CreateChild();
    wallNode.scale = Vector3(10.0f, 3.0f, 0.5f);
    StaticModel@ wallObject = wallNode.CreateComponent("StaticModel");
    wallObject.model = cache.GetResource("Model", "Models/Box.mdl");
    wallObject.castShadows = true;
    
    Node@ characterNode = scene_.CreateChild();
    characterNode.position = Vector3(0.0f, 0.0f, 2.0f);
    AnimatedModel@ characterObject = characterNode.CreateComponent("AnimatedModel");
    characterObject.model = cache.GetResource("Model", "Models/Mutant/Mutant.mdl");
    characterObject.material = cache.GetResource("Material", "Materials/Mutant.xml");
    characterObject.castShadows = true;
    AnimationController@ characterAnimCtrl = characterNode.CreateComponent("AnimationController");
    characterAnimCtrl.Play("Models/Mutant/Mutant_HipHop1.ani", 0, true, 0.0f);

    SubscribeToEvent("Update", "HandleUpdate");

    renderer.SetDefaultRenderPath(cache.GetResource("XMLFile", "RenderPaths/MyForward.xml"));
    Viewport@ viewport = Viewport(scene_, cameraNode.GetComponent("Camera"));
    viewport.renderPath.Append(cache.GetResource("XMLFile", "PostProcess/FXAA3.xml"));
    renderer.viewports[0] = viewport;
}

void HandleUpdate(StringHash eventType, VariantMap& eventData)
{
    float timeStep = eventData["TimeStep"].GetFloat();
    
    const float MOVE_SPEED = 20.0f;
    const float MOUSE_SENSITIVITY = 0.1f;

    IntVector2 mouseMove = input.mouseMove;
    cameraYaw += MOUSE_SENSITIVITY * mouseMove.x;
    cameraPitch += MOUSE_SENSITIVITY * mouseMove.y;
    cameraPitch = Clamp(cameraPitch, -90.0f, 90.0f);
    cameraNode.rotation = Quaternion(cameraPitch, cameraYaw, 0.0f);

    if (input.keyDown[KEY_W])
        cameraNode.Translate(Vector3(0.0f, 0.0f, 1.0f) * MOVE_SPEED * timeStep);
    if (input.keyDown[KEY_S])
        cameraNode.Translate(Vector3(0.0f, 0.0f, -1.0f) * MOVE_SPEED * timeStep);
    if (input.keyDown[KEY_A])
        cameraNode.Translate(Vector3(-1.0f, 0.0f, 0.0f) * MOVE_SPEED * timeStep);
    if (input.keyDown[KEY_D])
        cameraNode.Translate(Vector3(1.0f, 0.0f, 0.0f) * MOVE_SPEED * timeStep);
    if (input.keyDown[KEY_E])
        cameraNode.Translate(Vector3(0.0f, 1.0f, 0.0f) * MOVE_SPEED * timeStep);
    if (input.keyDown[KEY_Q])
        cameraNode.Translate(Vector3(0.0f, -1.0f, 0.0f) * MOVE_SPEED * timeStep);

    if (input.keyPress[KEY_SPACE])
        renderer.viewports[0].renderPath.ToggleEnabled("WallHack");

    if (input.keyPress[KEY_ESCAPE])
        engine.Exit();
}
