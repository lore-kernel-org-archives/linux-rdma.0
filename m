From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 2/2] opensm: use OSM_LOG_INFO on duplicate torus port
 order parsing
Date: Fri, 3 Jun 2011 13:49:10 +0300
Message-ID: <20110603104910.GG1098@calypso.voltaire.com>
References: <4DE6BD7A.9030102@sandia.gov>
 <1306967581-1015-2-git-send-email-jaschut@sandia.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1306967581-1015-2-git-send-email-jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Cc: alexne-smomgflXvOZWk0Htik3J/w@public.gmane.org, davem-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 16:33 Wed 01 Jun     , Jim Schutt wrote:
> Since it doesn't cause OpenSM to exit, it isn't an error.
> We just want to give the admin information that will allow them
> to clean up their configuration.
> 
> Signed-off-by: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
> ---

Applied, thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
