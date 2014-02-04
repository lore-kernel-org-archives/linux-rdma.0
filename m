From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 1/1] OpenSM: osm_ucast_dfsssp.c - prevent double free
 error
Date: Tue, 04 Feb 2014 08:44:26 -0500
Message-ID: <52F0EEBA.9080002@dev.mellanox.co.il>
References: <1391516326-11399-1-git-send-email-domke.j.aa@m.titech.ac.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1391516326-11399-1-git-send-email-domke.j.aa@m.titech.ac.jp>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jens Domke <domke.j.aa@m.titech.ac.jp>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 2/4/2014 7:18 AM, Jens Domke wrote:
> an error in the routing execution can cause a second
> free() call on sw_list, which results in a 'double free' error
> 
> Signed-off-by: Jens Domke <domke.j.aa@m.titech.ac.jp>

Thanks. Applied.

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
