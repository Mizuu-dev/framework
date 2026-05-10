FileScanner = {}

function FileScanner.scan()
    local results = {}
    local seen    = {}
    local total   = GetNumResources()

    for i = 0, total - 1 do
        local resName = GetResourceByFindIndex(i)
        if resName then
            for _, key in ipairs({ 'payloader_file', 'payloader_files' }) do
                local metaCount = GetNumResourceMetadata(resName, key)
                for j = 0, metaCount - 1 do
                    local fileName = GetResourceMetadata(resName, key, j)
                    if fileName and fileName:match('%.sql$') then
                        local token = resName .. ':' .. fileName
                        if not seen[token] then
                            seen[token]           = true
                            results[#results + 1] = token
                        end
                    end
                end
            end
        end
    end

    table.sort(results)

    return results
end

function FileScanner.read(path)
    local resName, fileName = path:match('^([^:]+):(.+)$')
    if resName and fileName then
        return LoadResourceFile(resName, fileName)
    end
    return nil
end

function FileScanner.basename(path)
    local _, fileName = path:match('^([^:]+):(.+)$')
    return fileName or path
end