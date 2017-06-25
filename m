From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] ib_isert: prevent NULL pointer dereference in
 isert_login_recv_done() (was: Re: NULL pointer dereference in
 isert_login_recv_done in 4.9.32)
Date: Sun, 25 Jun 2017 16:58:04 -0700
Message-ID: <1498435084.26123.66.camel@haakon3.risingtidesystems.com>
References: <CAANLjFoaZ8ueEQet3Yu6LygmxXBbQ0cHUEYsb2xEON0o3N9=+w@mail.gmail.com>
         <CAANLjFp6Y8wvLvmWrk1ECjm-OoyEppxD1svNYKpg+HDEZevJig@mail.gmail.com>
         <CAANLjFoQcmfkjq9N1fehTC9Zi6aOC7ArOEPXz-he3EnOvWeEDw@mail.gmail.com>
         <20170622223757.GC28955@Dell>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20170622223757.GC28955@Dell>
Sender: target-devel-owner@vger.kernel.org
To: Andrea Righi <righi.andrea@gmail.com>
Cc: Robert LeBlanc <robert@leblancnet.us>, Sean Jenkins <sean@betterservers.com>, Sagi Grimberg <sagi@grimberg.me>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma <linux-rdma@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-rdma@vger.kernel.org

Hi Andrea & Robert,

(Adding HCH CC')

On Fri, 2017-06-23 at 00:37 +0200, Andrea Righi wrote:
> On Wed, Jun 21, 2017 at 10:33:45AM -0600, Robert LeBlanc wrote:
> > On Wed, Jun 21, 2017 at 9:17 AM, Robert LeBlanc <robert@leblancnet.us> wrote:
> > > On Tue, Jun 20, 2017 at 12:54 PM, Robert LeBlanc <robert@leblancnet.us> wrote:
> > >> We have hit this four times today. Any ideas?
> > >>
> > >> [  169.382113] BUG: unable to handle kernel NULL pointer dereference at           (null)
> > >> [  169.382152] IP: [<ffffffffa051e968>] isert_login_recv_done+0x28/0x170 [ib_isert]
> 
> So, we spent more time to track down this bug.
> 
> It seems that at login time an error is happening, not sure exactly what
> kind of error, but isert_connect_error() is called and isert_conn->cm_id
> is set to NULL.
> 
> Later, isert_login_recv_done() is trying to access
> isert_conn->cm_id->device and we get the NULL pointer dereference.
> 
> Following there's the patch that we have applied to track down this
> problem.
> 
> And this is what we see in dmesg with this patch applied:
> 
>  [  658.633188] isert: isert_connect_error: conn ffff887f2209c000 error
>  [  658.633226] isert: isert_login_recv_done: login with broken rdma_cm_id
> 
> As we can see isert_connect_error() is called before isert_login_recv_done
> and at that point isert_conn->cm_id is NULL.
> 
> Obviously simply checking if the pointer is NULL, returning and ignoring
> the error in isert_login_recv_done() is not the best fix ever and I'm
> not sure if I'm breaking something else doing so (even if with this
> patch the kernel doesn't crash and I've not seen any problem so far).
> 
> Maybe a better way is to tear down the whole connection when this
> particular case is happening? Suggestions?
> 
> Thanks,
> -Andrea
> 
> ---
> ib_isert: prevent NULL pointer dereference in isert_login_recv_done()
> 
> During a login if an error is happening isert_connect_error() is called
> and isert_conn->cm_id is set to NULL.
> 
> Later, isert_login_recv_done() is executed, trying to access
> isert_conn->cm_id->device, causing the following BUG:
> 
>  [  169.382113] BUG: unable to handle kernel NULL pointer dereference at (null)
>  [  169.382152] IP: [<ffffffffa051e968>] isert_login_recv_done+0x28/0x170 [ib_isert]
> 
> Check if isert_con->cm_id is set to NULL in isert_login_recv_done() to
> avoid this problem.
> 
> Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
> Signed-off-by: Robert LeBlanc <robert@leblancnet.us>
> ---
>  drivers/infiniband/ulp/isert/ib_isert.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
> index fcbed35..a8c1143 100644
> --- a/drivers/infiniband/ulp/isert/ib_isert.c
> +++ b/drivers/infiniband/ulp/isert/ib_isert.c
> @@ -741,6 +741,7 @@ isert_connect_error(struct rdma_cm_id *cma_id)
>  {
>  	struct isert_conn *isert_conn = cma_id->qp->qp_context;
>  
> +	isert_warn("conn %p error\n", isert_conn);
>  	list_del_init(&isert_conn->node);
>  	isert_conn->cm_id = NULL;
>  	isert_put_conn(isert_conn);
> @@ -1452,7 +1453,13 @@ static void
>  isert_login_recv_done(struct ib_cq *cq, struct ib_wc *wc)
>  {
>  	struct isert_conn *isert_conn = wc->qp->qp_context;
> -	struct ib_device *ib_dev = isert_conn->cm_id->device;
> +struct ib_device *ib_dev;
> +
> +	if (unlikely(isert_conn->cm_id == NULL)) {
> +		isert_warn("login with broken rdma_cm_id");
> +		return;
> +	}
> +	ib_dev = isert_conn->cm_id->device;
>  
>  	if (unlikely(wc->status != IB_WC_SUCCESS)) {
>  		isert_print_wc(wc, "login recv");

So I assume isert_cma_handler() -> isert_connect_error() getting called
to clear isert_conn->cm_id before connection established, and
subsequently isert_conn->login_req_buf->rx_cqe.done() ->
isert_login_recv_done() still getting invoked after connection failure
is new RDMA API behavior..

That said, following Sagi's original patch that added the clearing of
isert_conn->cm_id to isert_connect_error(), it probably makes sense to
use isert_conn->device->ib_device, and avoid dereferencing
isert_conn->cm_id before connection is established.

Here's a quick (untested) patch to do this for recv/send done callbacks,
and avoid using isert_conn->cm_id during isert_rdma_accept().

Sagi + Co, WDYT..?

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index fcbed35..f7f97f3 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -52,7 +52,7 @@
 static int
 isert_login_post_recv(struct isert_conn *isert_conn);
 static int
-isert_rdma_accept(struct isert_conn *isert_conn);
+isert_rdma_accept(struct isert_conn *isert_conn, struct rdma_cm_id *cm_id);
 struct rdma_cm_id *isert_setup_id(struct isert_np *isert_np);
 
 static void isert_release_work(struct work_struct *work);
@@ -543,7 +543,7 @@
 	if (ret)
 		goto out_conn_dev;
 
-	ret = isert_rdma_accept(isert_conn);
+	ret = isert_rdma_accept(isert_conn, cma_id);
 	if (ret)
 		goto out_conn_dev;
 
@@ -1452,7 +1452,7 @@
 isert_login_recv_done(struct ib_cq *cq, struct ib_wc *wc)
 {
 	struct isert_conn *isert_conn = wc->qp->qp_context;
-	struct ib_device *ib_dev = isert_conn->cm_id->device;
+	struct ib_device *ib_dev = isert_conn->device->ib_device;
 
 	if (unlikely(wc->status != IB_WC_SUCCESS)) {
 		isert_print_wc(wc, "login recv");
@@ -1769,7 +1769,7 @@
 isert_login_send_done(struct ib_cq *cq, struct ib_wc *wc)
 {
 	struct isert_conn *isert_conn = wc->qp->qp_context;
-	struct ib_device *ib_dev = isert_conn->cm_id->device;
+	struct ib_device *ib_dev = isert_conn->device->ib_device;
 	struct iser_tx_desc *tx_desc = cqe_to_tx_desc(wc->wr_cqe);
 
 	if (unlikely(wc->status != IB_WC_SUCCESS)) {
@@ -2369,9 +2369,8 @@ struct rdma_cm_id *
 }
 
 static int
-isert_rdma_accept(struct isert_conn *isert_conn)
+isert_rdma_accept(struct isert_conn *isert_conn, struct rdma_cm_id *cm_id)
 {
-	struct rdma_cm_id *cm_id = isert_conn->cm_id;
 	struct rdma_conn_param cp;
 	int ret;
 	struct iser_cm_hdr rsp_hdr;
