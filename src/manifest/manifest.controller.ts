import { Controller, Get } from "@nestjs/common";

@Controller("manifest")
export class ManifestController {
  @Get()
  test(): string {
    return "Manifest";
  }
}
