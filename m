From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] remove unnecessary leading '/' from filename
Date: Sat, 28 Nov 2009 16:28:15 +0200
Message-ID: <20091128142815.GD16607@me>
References: <784A3771E5D143179461A7D5151AE78C@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <784A3771E5D143179461A7D5151AE78C-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Stan C. Smith" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, 'linux-rdma' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 16:46 Wed 07 Oct     , Stan C. Smith wrote:
> 
> In osm_db_domain_init() the filename is appended to a path string 'db_dir_name' which contains a trailing '/'.
> Remove extra '/'.
> 
> Signed-off-by: stan smith <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Applied. Thanks.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
