From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PATCH 1/3] ib core: Make device counter infrastructure dynamic
Date: Fri, 18 Mar 2016 08:20:09 +0200
Message-ID: <20160318062009.GI25216@leon.nu>
References: <20160315155441.222586021@linux.com>
 <20160315155455.173645653@linux.com>
 <20160317072354.GB25216@leon.nu>
 <20160317081716.GD25216@leon.nu>
 <alpine.DEB.2.20.1603172057030.18714@east.gentwo.org>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.1603172057030.18714-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, alonvi-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 17, 2016 at 08:57:23PM -0500, Christoph Lameter wrote:
> On Thu, 17 Mar 2016, Leon Romanovsky wrote:
> 
> > I didn't check for other proposals except mlx5 but I assume that in case nothing was filled
> > there, this function should return NOSUPPORT.
> 
> The function simply does not create the directory. So we are fine.
> 

It makes the stat.name check redundant. Do you have scenario in mind
where ret == 0 and stat.name == NULL as a result of call to the
function?

Thanks
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
