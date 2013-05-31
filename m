From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 2/2] OpenSM: DFSSSP - workaround for better VL balancing
Date: Fri, 31 May 2013 05:48:25 -0400
Message-ID: <51A871E9.50600@dev.mellanox.co.il>
References: <1369880550-3031-1-git-send-email-domke.j.aa@m.titech.ac.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1369880550-3031-1-git-send-email-domke.j.aa@m.titech.ac.jp>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jens Domke <domke.j.aa@m.titech.ac.jp>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Torsten Hoefler <htor-gy3b+zu4XSAfv37vnLkPlQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 5/29/2013 10:22 PM, Jens Domke wrote:
> Currently, DFSSSP maps the src/dest paths statically to certain VLs.
> Especially for deadlock-free topologies this can result in an
> unfair balancing. Some VLs within one link might be overused,
> which results in slower bandwidth for some src/dest pairs.
> 
> The fix changes the VL assignment in two ways: first we balance the
> number of paths per VL; and second we randomly assign the VL
> as long as this doesn't violate the deadlock-freedom.
> 
> 1) The balancing splits the paths across available free VLs, so that
> the maximal number of paths per VL is minimized. We save the number
> of VLs for each deadlock-free channel dependency graph. E.g. for
> 8 VLs, paths per CDG: {14,5,1} => balanced VLs: {{3,3,3,3,2},{3,2},1}
> we have 5 VLs to choose from for CDG(0), two for CDG(1) and
> one for CDG(2).
> 
> 2) get_dfsssp_sl(...) will use the information of (1) to randomly
> assign the VL for one src/dest pair within the possible number of
> VLs. E.g. for a src/dest pair of CDG(0) we have 5 VLs to choose from,
> therefore VL := baseVL + rand()%5
> 
> Signed-off-by: Jens Domke <domke.j.aa@m.titech.ac.jp>

Thanks. Applied with removal of debug code.

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
