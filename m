From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm: configure multicast only once during sweep
Date: Sun, 13 Mar 2011 19:23:56 +0200
Message-ID: <20110313172356.GE14371@calypso.voltaire.com>
References: <4D25F029.1080005@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4D25F029.1080005-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Dorfman <elido-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sasha Khapyorsky <IMCEAEX-_O=VOLTAIRE+20ADVANCED+20DATA+20SECURITY_OU=VOLTAIRE_CN=RECIPIENTS_CN=SASHAK-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Vladimir Koushnir <vladimirk-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 18:39 Thu 06 Jan     , Eli Dorfman (Voltaire) wrote:
> [PATCH] configure multicast only once during sweep
> 
> opensm performed multicast configuration twice during sweep by calling
> two different function that are very similar.
> remove osm_mcast_mgr_process() which had a bug and didn't clear mlid bit
> after configuration and rename osm_mcast_mgr_process_mgroups()
> to osm_mcast_mgr_process()
> 
> Signed-off-by: Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>

Applied. Thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
