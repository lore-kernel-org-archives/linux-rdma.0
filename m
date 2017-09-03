From: Tariq Toukan <tariqt@mellanox.com>
Subject: Re: [PATCH 7/10] net/mlx4_core: Use ARRAY_SIZE macro
Date: Sun, 3 Sep 2017 16:14:38 +0300
Message-ID: <d11331cc-d5d8-e4bb-2a0b-c97c46b5b0a3@mellanox.com>
References: <1504439110050-939061377-0-diffsplit-thomas@m3y3r.de>
 <1504439110050-1961876957-7-diffsplit-thomas@m3y3r.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1504439110050-1961876957-7-diffsplit-thomas@m3y3r.de>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Thomas Meyer <thomas@m3y3r.de>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org



On 03/09/2017 3:19 PM, Thomas Meyer wrote:
> Use ARRAY_SIZE macro, rather than explicitly coding some variant of it
> yourself.
> Found with: find -type f -name "*.c" -o -name "*.h" | xargs perl -p -i -e
> 's/\bsizeof\s*\(\s*(\w+)\s*\)\s*\ /\s*sizeof\s*\(\s*\1\s*\[\s*0\s*\]\s*\)
> /ARRAY_SIZE(\1)/g' and manual check/verification.
> 
> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
> ---


Reviewed-by: Tariq Toukan <tariqt@mellanox.com>

Thanks Thomas!
