From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/3] ib core: Make device counter infrastructure
 dynamic
Date: Fri, 18 Mar 2016 09:33:28 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1603180932310.25235@east.gentwo.org>
References: <20160315155441.222586021@linux.com> <20160315155455.173645653@linux.com> <20160317072354.GB25216@leon.nu> <20160317081716.GD25216@leon.nu> <alpine.DEB.2.20.1603172057030.18714@east.gentwo.org> <20160318062009.GI25216@leon.nu>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160318062009.GI25216-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, alonvi-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, 18 Mar 2016, Leon Romanovsky wrote:

> It makes the stat.name check redundant. Do you have scenario in mind
> where ret == 0 and stat.name == NULL as a result of call to the
> function?

This is a function provided by those writing the device drivers. Better
check that the function filled out at least one required value.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
