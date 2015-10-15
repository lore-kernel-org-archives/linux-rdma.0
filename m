From: "Dave Goodell (dgoodell)" <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] usnic: corretly check failed allocation
Date: Thu, 15 Oct 2015 17:17:57 +0000
Message-ID: <1D90F355-D799-4E9E-9526-836B71355109@cisco.com>
References: <1444926460-29333-1-git-send-email-wuninsu@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444926460-29333-1-git-send-email-wuninsu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Content-ID: <42CDFC178E7BDD47A540F672B21DB7D5-WwaMAgPkaIIluPl5bxqUMw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Insu Yun <wuninsu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org" <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "taesoo-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org" <taesoo-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org>, "yeongjin.jang-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org" <yeongjin.jang-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org>, "insu-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org" <insu-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Oct 15, 2015, at 11:27 AM, Insu Yun <wuninsu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> 
> Since ib_alloc_device returns allocated memory address, not error, 
> it should be checked as IS_NULL, not IS_ERR_OR_NULL.
> 
> Signed-off-by: Insu Yun <wuninsu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> drivers/infiniband/hw/usnic/usnic_ib_main.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)

There's a typo in the subject ("corretly"-->"correctly").

Out of curiosity, what led you to spot this?  General code inspection or did this come out of some tool?

> diff --git a/drivers/infiniband/hw/usnic/usnic_ib_main.c b/drivers/infiniband/hw/usnic/usnic_ib_main.c
> index 34c49b8..7c5f602 100644
> --- a/drivers/infiniband/hw/usnic/usnic_ib_main.c
> +++ b/drivers/infiniband/hw/usnic/usnic_ib_main.c
> @@ -328,14 +328,14 @@ static void *usnic_ib_device_add(struct pci_dev *dev)
> 	netdev = pci_get_drvdata(dev);
> 
> 	us_ibdev = (struct usnic_ib_dev *)ib_alloc_device(sizeof(*us_ibdev));
> -	if (IS_ERR_OR_NULL(us_ibdev)) {
> +	if (!us_ibdev) {
> 		usnic_err("Device %s context alloc failed\n",
> 				netdev_name(pci_get_drvdata(dev)));
> 		return ERR_PTR(us_ibdev ? PTR_ERR(us_ibdev) : -EFAULT);

I think this can become:

return ERR_PTR(-EFAULT);

> 	}
> 
> 	us_ibdev->ufdev = usnic_fwd_dev_alloc(dev);
> -	if (IS_ERR_OR_NULL(us_ibdev->ufdev)) {
> +	if (!us_ibdev->ufdev) {
> 		usnic_err("Failed to alloc ufdev for %s with err %ld\n",
> 				pci_name(dev), PTR_ERR(us_ibdev->ufdev));

This PTR_ERR and message make less sense now.

-Dave

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
