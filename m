From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 1/1] OpenSM: dfsssp - add missing and change existing
 return values
Date: Wed, 31 Jul 2013 10:53:48 -0400
Message-ID: <51F924FC.1080107@dev.mellanox.co.il>
References: <1375250646-22892-1-git-send-email-domke.j.aa@m.titech.ac.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1375250646-22892-1-git-send-email-domke.j.aa@m.titech.ac.jp>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jens Domke <domke.j.aa@m.titech.ac.jp>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Torsten Hoefler <htor-gy3b+zu4XSAfv37vnLkPlQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/31/2013 2:04 AM, Jens Domke wrote:
> a) this patch sets the 'err' variable correclty for the function
>    dfsssp_remove_deadlocks() for the case, that the error occurs within
>    the function and not within a subroutine
> b) the functions dfsssp_build_graph() and dfsssp_do_dijkstra_routing()
>    now return -1 instead of 1 to indicate an error to be in compliance
>    with the implementation of ucast_mgr_route() in osm_ucast_mgr.c
> 
> Signed-off-by: Jens Domke <domke.j.aa@m.titech.ac.jp>

Thanks. Applied.

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
