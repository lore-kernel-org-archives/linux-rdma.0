From: Andrea Righi <righi.andrea@gmail.com>
Subject: [PATCH] ib_isert: prevent NULL pointer dereference in
 isert_login_recv_done() (was: Re: NULL pointer dereference in
 isert_login_recv_done in 4.9.32)
Date: Fri, 23 Jun 2017 00:37:57 +0200
Message-ID: <20170622223757.GC28955@Dell>
References: <CAANLjFoaZ8ueEQet3Yu6LygmxXBbQ0cHUEYsb2xEON0o3N9=+w@mail.gmail.com>
 <CAANLjFp6Y8wvLvmWrk1ECjm-OoyEppxD1svNYKpg+HDEZevJig@mail.gmail.com>
 <CAANLjFoQcmfkjq9N1fehTC9Zi6aOC7ArOEPXz-he3EnOvWeEDw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAANLjFoQcmfkjq9N1fehTC9Zi6aOC7ArOEPXz-he3EnOvWeEDw@mail.gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: Robert LeBlanc <robert@leblancnet.us>
Cc: Sean Jenkins <sean@betterservers.com>, Sagi Grimberg <sagi@grimberg.me>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma <linux-rdma@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 21, 2017 at 10:33:45AM -0600, Robert LeBlanc wrote:
> On Wed, Jun 21, 2017 at 9:17 AM, Robert LeBlanc <robert@leblancnet.us> wrote:
> > On Tue, Jun 20, 2017 at 12:54 PM, Robert LeBlanc <robert@leblancnet.us> wrote:
> >> We have hit this four times today. Any ideas?
> >>
> >> [  169.382113] BUG: unable to handle kernel NULL pointer dereference at           (null)
> >> [  169.382152] IP: [<ffffffffa051e968>] isert_login_recv_done+0x28/0x170 [ib_isert]

So, we spent more time to track down this bug.

It seems that at login time an error is happening, not sure exactly what
kind of error, but isert_connect_error() is called and isert_conn->cm_id
is set to NULL.

Later, isert_login_recv_done() is trying to access
isert_conn->cm_id->device and we get the NULL pointer dereference.

Following there's the patch that we have applied to track down this
problem.

And this is what we see in dmesg with this patch applied:

 [  658.633188] isert: isert_connect_error: conn ffff887f2209c000 error
 [  658.633226] isert: isert_login_recv_done: login with broken rdma_cm_id

As we can see isert_connect_error() is called before isert_login_recv_done
and at that point isert_conn->cm_id is NULL.

Obviously simply checking if the pointer is NULL, returning and ignoring
the error in isert_login_recv_done() is not the best fix ever and I'm
not sure if I'm breaking something else doing so (even if with this
patch the kernel doesn't crash and I've not seen any problem so far).

Maybe a better way is to tear down the whole connection when this
particular case is happening? Suggestions?

Thanks,
-Andrea

---
ib_isert: prevent NULL pointer dereference in isert_login_recv_done()

During a login if an error is happening isert_connect_error() is called
and isert_conn->cm_id is set to NULL.

Later, isert_login_recv_done() is executed, trying to access
isert_conn->cm_id->device, causing the following BUG:

 [  169.382113] BUG: unable to handle kernel NULL pointer dereference at (null)
 [  169.382152] IP: [<ffffffffa051e968>] isert_login_recv_done+0x28/0x170 [ib_isert]

Check if isert_con->cm_id is set to NULL in isert_login_recv_done() to
avoid this problem.

Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
Signed-off-by: Robert LeBlanc <robert@leblancnet.us>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index fcbed35..a8c1143 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -741,6 +741,7 @@ isert_connect_error(struct rdma_cm_id *cma_id)
 {
 	struct isert_conn *isert_conn = cma_id->qp->qp_context;
 
+	isert_warn("conn %p error\n", isert_conn);
 	list_del_init(&isert_conn->node);
 	isert_conn->cm_id = NULL;
 	isert_put_conn(isert_conn);
@@ -1452,7 +1453,13 @@ static void
 isert_login_recv_done(struct ib_cq *cq, struct ib_wc *wc)
 {
 	struct isert_conn *isert_conn = wc->qp->qp_context;
-	struct ib_device *ib_dev = isert_conn->cm_id->device;
+struct ib_device *ib_dev;
+
+	if (unlikely(isert_conn->cm_id == NULL)) {
+		isert_warn("login with broken rdma_cm_id");
+		return;
+	}
+	ib_dev = isert_conn->cm_id->device;
 
 	if (unlikely(wc->status != IB_WC_SUCCESS)) {
 		isert_print_wc(wc, "login recv");
-- 
2.7.4
