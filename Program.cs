using System.Text.Json.Serialization;

var builder = WebApplication.CreateSlimBuilder(args);

builder.Services.AddHttpClient();
builder
    .Services
    .ConfigureHttpJsonOptions(options =>
    {
        options.SerializerOptions.TypeInfoResolverChain.Insert(0, AppJsonSerializerContext.Default);
    });

var app = builder.Build();

var appsApi = app.MapGroup("/api");
// appsApi.MapGet(
//     "/{id}",
//     (HttpRequest request, IHttpClientFactory httpClientFactory) =>
//     {
//         var id request.RouteValues["id"];
//         var dl = request.QueryString.;
//
//         if (dl.)
//         {
//             
//         }
//         
//         var client = httpClientFactory.CreateClient();
//         var 
//
//         if ()
//         {
//             
//         }
//     }
// );

app.Run();

internal record AppManifest(string Url, string Name, string Version, string Hash);

[JsonSerializable(typeof(AppManifest))]
internal partial class AppJsonSerializerContext : JsonSerializerContext { }
