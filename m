From: Dave Goodell <dgoodell@cisco.com>
Subject: Re: [PATCH] IB/usnic: delete unneeded IS_ERR test
Date: Tue, 22 Dec 2015 10:29:03 -0500
Message-ID: <20151222152903.GA23118@DGOODELL-M-F02A.cisco.com>
References: <1450558139-466-1-git-send-email-Julia.Lawall@lip6.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1450558139-466-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Christian Benvenuti <benve@cisco.com>, kernel-janitors@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Nelson Escobar <neescoba@cisco.com>
List-Id: linux-rdma@vger.kernel.org

[copying Nelson too]

On Sat, Dec 19, 2015 at 09:48:59PM +0100, Julia Lawall wrote:
> kzalloc doesn't return ERR_PTR, so there is no need to test for it.
> 
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression x,e;
> @@
> 
> * x = kzalloc(...)
> ... when != x = e
> * IS_ERR_OR_NULL(x)
> // </smpl>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Reviewed-by: Dave Goodell <dgoodell@cisco.com>

-Dave
