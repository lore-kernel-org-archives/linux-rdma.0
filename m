From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/2] RDMA/uverbs: Fix the check for port number
Date: Fri, 14 Jul 2017 08:48:01 +0200
Message-ID: <20170714064801.GB16816@kroah.com>
References: <1499974658-6180-1-git-send-email-mustafa.ismail@intel.com>
 <1499974658-6180-2-git-send-email-mustafa.ismail@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1499974658-6180-2-git-send-email-mustafa.ismail@intel.com>
Sender: stable-owner@vger.kernel.org
To: Mustafa Ismail <mustafa.ismail@intel.com>
Cc: linux-rdma@vger.kernel.org, dledford@redhat.com, swise@opengridcomputing.com, linux-kernel@vger.kernel.org, stable@vger.kernel.org, shiraz.saleem@intel.com
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 13, 2017 at 02:37:37PM -0500, Mustafa Ismail wrote:
> The port number is only valid if IB_QP_PORT is set in the mask.
> So only check port number if it is valid to prevent modify_qp from
> failing due to an invalid port number.
> 
> Fixes: 5ecce4c9b17b("Check port number supplied by user verbs cmds")
> Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
> ---
>  drivers/infiniband/core/uverbs_cmd.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
