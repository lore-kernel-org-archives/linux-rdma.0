From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 1/4] IB/isert: properly type the login buffer
Date: Wed, 17 Feb 2016 02:29:52 -0800
Message-ID: <20160217102952.GA23954@infradead.org>
References: <1455567060-18381-1-git-send-email-hch@lst.de>
 <1455567060-18381-2-git-send-email-hch@lst.de>
 <20160216044058.GA27580@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160216044058.GA27580-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Feb 16, 2016 at 06:40:58AM +0200, Leon Romanovsky wrote:
> > -	isert_conn->login_buf = kzalloc(ISCSI_DEF_MAX_RECV_SEG_LEN +
> > -					ISER_RX_LOGIN_SIZE, GFP_KERNEL);
> > -	if (!isert_conn->login_buf) {
> > -		isert_err("Unable to allocate isert_conn->login_buf\n");
> > +	isert_conn->login_req_buf =
> > +		kzalloc(ISCSI_DEF_MAX_RECV_SEG_LEN, GFP_KERNEL);
> > +	if (!isert_conn->login_req_buf) {
> > +		isert_err("Unable to allocate isert_conn->login_req_buf\n");
> 
> Please don't print additional allocation failure messages after
> kzalloc/kmalloc.

I don't personally like that style, but it's prelevant in this driver,
and without an explicit request from the maintainer (Sagi) I'm going
to stick to the drivers style.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
