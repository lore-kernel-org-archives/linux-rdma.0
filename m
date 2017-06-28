From: Andrea Righi <righi.andrea@gmail.com>
Subject: Re: [PATCH] ib_isert: prevent NULL pointer dereference in
 isert_login_recv_done() (was: Re: NULL pointer dereference in
 isert_login_recv_done in 4.9.32)
Date: Wed, 28 Jun 2017 19:53:54 +0200
Message-ID: <20170628175354.GB1769@Dell>
References: <CAANLjFoaZ8ueEQet3Yu6LygmxXBbQ0cHUEYsb2xEON0o3N9=+w@mail.gmail.com>
 <CAANLjFp6Y8wvLvmWrk1ECjm-OoyEppxD1svNYKpg+HDEZevJig@mail.gmail.com>
 <CAANLjFoQcmfkjq9N1fehTC9Zi6aOC7ArOEPXz-he3EnOvWeEDw@mail.gmail.com>
 <20170622223757.GC28955@Dell>
 <1498435084.26123.66.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1498435084.26123.66.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Robert LeBlanc <robert@leblancnet.us>, Sean Jenkins <sean@betterservers.com>, Sagi Grimberg <sagi@grimberg.me>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma <linux-rdma@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-rdma@vger.kernel.org

On Sun, Jun 25, 2017 at 04:58:04PM -0700, Nicholas A. Bellinger wrote:
...
> So I assume isert_cma_handler() -> isert_connect_error() getting called
> to clear isert_conn->cm_id before connection established, and
> subsequently isert_conn->login_req_buf->rx_cqe.done() ->
> isert_login_recv_done() still getting invoked after connection failure
> is new RDMA API behavior..
> 
> That said, following Sagi's original patch that added the clearing of
> isert_conn->cm_id to isert_connect_error(), it probably makes sense to
> use isert_conn->device->ib_device, and avoid dereferencing
> isert_conn->cm_id before connection is established.
> 
> Here's a quick (untested) patch to do this for recv/send done callbacks,
> and avoid using isert_conn->cm_id during isert_rdma_accept().
> 
> Sagi + Co, WDYT..?

Just tested this patch, I wasn't able to reproduce the NULL pointer
dereference or any other bugs, so this fix seems safe enough to me.

Tested-by: Andrea Righi <righi.andrea@gmail.com>

> 
> diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
> index fcbed35..f7f97f3 100644
> --- a/drivers/infiniband/ulp/isert/ib_isert.c
> +++ b/drivers/infiniband/ulp/isert/ib_isert.c
> @@ -52,7 +52,7 @@
>  static int
>  isert_login_post_recv(struct isert_conn *isert_conn);
>  static int
> -isert_rdma_accept(struct isert_conn *isert_conn);
> +isert_rdma_accept(struct isert_conn *isert_conn, struct rdma_cm_id *cm_id);
>  struct rdma_cm_id *isert_setup_id(struct isert_np *isert_np);
>  
>  static void isert_release_work(struct work_struct *work);
> @@ -543,7 +543,7 @@
>  	if (ret)
>  		goto out_conn_dev;
>  
> -	ret = isert_rdma_accept(isert_conn);
> +	ret = isert_rdma_accept(isert_conn, cma_id);
>  	if (ret)
>  		goto out_conn_dev;
>  
> @@ -1452,7 +1452,7 @@
>  isert_login_recv_done(struct ib_cq *cq, struct ib_wc *wc)
>  {
>  	struct isert_conn *isert_conn = wc->qp->qp_context;
> -	struct ib_device *ib_dev = isert_conn->cm_id->device;
> +	struct ib_device *ib_dev = isert_conn->device->ib_device;
>  
>  	if (unlikely(wc->status != IB_WC_SUCCESS)) {
>  		isert_print_wc(wc, "login recv");
> @@ -1769,7 +1769,7 @@
>  isert_login_send_done(struct ib_cq *cq, struct ib_wc *wc)
>  {
>  	struct isert_conn *isert_conn = wc->qp->qp_context;
> -	struct ib_device *ib_dev = isert_conn->cm_id->device;
> +	struct ib_device *ib_dev = isert_conn->device->ib_device;
>  	struct iser_tx_desc *tx_desc = cqe_to_tx_desc(wc->wr_cqe);
>  
>  	if (unlikely(wc->status != IB_WC_SUCCESS)) {
> @@ -2369,9 +2369,8 @@ struct rdma_cm_id *
>  }
>  
>  static int
> -isert_rdma_accept(struct isert_conn *isert_conn)
> +isert_rdma_accept(struct isert_conn *isert_conn, struct rdma_cm_id *cm_id)
>  {
> -	struct rdma_cm_id *cm_id = isert_conn->cm_id;
>  	struct rdma_conn_param cp;
>  	int ret;
>  	struct iser_cm_hdr rsp_hdr;
