From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: ib_isert RDMA_CM_EVENT_DEVICE_REMOVAL events
Date: Tue, 28 Oct 2014 14:05:17 -0700
Message-ID: <1414530317.26713.1.camel@haakon3.risingtidesystems.com>
References: <1414130562.15076.27.camel@haakon3.risingtidesystems.com>
	 <544FC5B2.70104@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <544FC5B2.70104@dev.mellanox.co.il>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: Or Gerlitz <ogerlitz@mellanox.com>, target-devel <target-devel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2014-10-28 at 18:34 +0200, Sagi Grimberg wrote:
> On 10/24/2014 9:02 AM, Nicholas A. Bellinger wrote:
> <SNIP>
> > AFAICT, it looks like the assumption in isert_disconnected_handler() to
> > dereference rdma_cm_id->context as isert_conn (in all cases) is wrong,
> > and the above RDMA_CM_EVENT_DEVICE_REMOVAL has iscsi_np stored in
> > ->context from the original rdma_create_id() at isert_setup_np() time.
> >
> > So, is there a way to tell the difference how rdma_cm_id->context should
> > be dereferenced when DEVICE_REMOVAL occurs..?  Does DEVICE_REMOVAL occur
> > on just the listener rdma_cm_id, or on all accepted children as well..?
> >
> > Anything else to consider wrt to other CMA events being kicked off into
> > isert_disconnected_handler()..?
> >
> 
> Hey Nic,
> 
> Terribly sorry for the late response, I'm juggling between 5 different
> projects...
> 
> This is indeed a bug, and I indeed noticed it.
> 
> This will happen if the network portal cm id listens on a specific
> address (e.g. not any - 0.0.0.0), in this case the cm id will acquire
> the relevant device (see rdma_bind_addr) - hence will sense
> DEVICE_REMOVAL events. And yes, all the accepted children will of course
> get the event as well.
> 
> Notice that cma_remove_one sequence (that fires DEVICE_REMOVAL event to
> all the relevant cma ids) requires the cmd is owner to finish cleanup
> before the end of the callback because in the end of it, it will allow
> the device to remove. So I do plan to get disconnected_handler to the
> callback instead of the deferred work.
> 
> I think this should make the bug you hit go away:
> iser-target: Handle DEVICE_REMOVAL event on network portal listener 
> correctly
> 
> In this case the cm_id->context is the isert_np, and the cm_id->qp
> is NULL, so use that to distinct the cases.
> 
> Since we don't expect any other events on this cm_id we can
> just return -1 for explicit termination of the cm_id by the
> cma layer.
> 
> Signed-off-by: Sagi Grimberg <sagig@mellanox.com>

Just verified that this resolves the specific OOPesen.

Queued up in target-pending/master, with a CC' to v3.10.y.

Thanks Sagi!

--nab
