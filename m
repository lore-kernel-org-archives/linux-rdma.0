From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC-v2 10/12] iser-target: Add logic for verbs
Date: Wed, 03 Apr 2013 13:45:36 -0700
Message-ID: <1365021936.11833.26.camel@haakon2.linux-iscsi.org>
References: <1363996536-30644-1-git-send-email-nab@linux-iscsi.org>
	 <1363996536-30644-11-git-send-email-nab@linux-iscsi.org>
	 <515A7843.1030804@mellanox.com>  <515BD496.7030005@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <515BD496.7030005@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: Or Gerlitz <ogerlitz@mellanox.com>
Cc: linux-rdma <linux-rdma@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2013-04-03 at 10:04 +0300, Or Gerlitz wrote:
> On 02/04/2013 09:18, Or Gerlitz wrote:
> > On 23/03/2013 01:55, Nicholas A. Bellinger wrote:
> >> +++ b/drivers/infiniband/ulp/isert/isert_verbs.h
> >> @@ -0,0 +1,5 @@
> >> +extern void isert_connect_release(struct isert_conn *);
> >> +extern void isert_put_conn(struct isert_conn *);
> >> +extern int isert_cma_handler(struct rdma_cm_id *, struct 
> >> rdma_cm_event *);
> >> +extern int isert_post_recv(struct isert_conn *, u32);
> >> +extern int isert_post_send(struct isert_conn *, struct iser_tx_desc *);
> >
> > why use extern here? maybe a left over from V1?
> 
> Nic, are you picking this comment one and its sister comment asking to 
> remove externs and use less header files?
> 

So in yesterday's target-pending/iser-target-wip push, source/headers
have been merged into a single ib_isert.[c,h], with the exception of the
existing isert_proto.h definitions.

This will be included as a single commit for RFC-v3.

--nab
