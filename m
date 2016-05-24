From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V2 libibverbs 2/7] Add member functions to poll an
 extended CQ
Date: Tue, 24 May 2016 11:34:37 -0600
Message-ID: <20160524173436.GA6337@obsidianresearch.com>
References: <1463658702-9975-1-git-send-email-yishaih@mellanox.com>
 <1463658702-9975-3-git-send-email-yishaih@mellanox.com>
 <20160519181933.GB26130@obsidianresearch.com>
 <c2a28acc-811a-84da-0793-88032de99b23@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <c2a28acc-811a-84da-0793-88032de99b23-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, May 23, 2016 at 06:31:52PM +0300, Yishai Hadas wrote:
> On 5/19/2016 9:19 PM, Jason Gunthorpe wrote:
> >On Thu, May 19, 2016 at 02:51:37PM +0300, Yishai Hadas wrote:
> >>+	int (*start_poll_ex)(struct ibv_cq_ex *current,
> >>+			     struct ibv_poll_cq_ex_attr *attr);
> >>+	int (*next_poll_ex)(struct ibv_cq_ex *current);
> >>+	void (*end_poll_ex)(struct ibv_cq_ex *current);
> >
> >Probably don't need the _ex here..
> 
> The '_ex' points that those functions support extension. (ibv_poll_cq_ex*
> attr, ibv_cq_ex). Their matching ibv_xxx wrappers also have _ex (e.g.
> ibv_start_poll_ex).
> Makes sense ?

No, don't use _ex unless there is an non-_ex variant.

> Specifically talking on 'opcode', the fact that it always exists doesn't
> mean that application will read it. Furthermore, in many cases application
> doesn't need it at all (e.g. only SEND is done, there is CQ per operation,
> etc.) In addition, in some cases it can be achieved based on the wr_id that
> is returned.
> 
> Re 'status' and 'wr_id':
> From our benchmark testing we found that coping the the data as part of the
> read_xxx is the major cost and not the function call, so not sure that
> coping the status/wr_id to ibv_cq_ex directly will really give a boost here.

Interesting result, OK.

> As part of our benchmark testing we grouped in one read call status & wr_id
> which are usually needed but didn't see a real impact. Even in UD flow,
> application may not need all fields so supplying a read_ud_info which will
> copy whole candidate fields might not be useful.
> As the API is extensible we may do further extensions in the future if will
> be proved to be useful.

Okay, if benchmarks support this..

> >Finally, these extended APIs really need to be always available - so
> >the core code should always provide a compatability wrapper for
> >providers that do not implement this API. The compat wrapper should
> >use the existing provider wc interface.
> 
> The compat layer will work in a non optimal way as it can't support batching
> and there will 2 copies, one from the HW CQ to ibv_wc even for not required
> fields, second, from the ibv_wc to the read_xxx output.

Yes. We should be encouraging all our drivers to implement the new API
and all our users to use the new API.

> However, if required it can be posted as some extra patches in another
> series.

Yes, this avoids the friction moving the users.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
