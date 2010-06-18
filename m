From: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH v2] allow passthrough of rmpp packets to user mad clients
Date: Fri, 18 Jun 2010 08:42:38 -0500
Message-ID: <4C2744E8AD2982428C5BFE523DF8CDCB49D09E7C2F@MNEXMB1.qlogic.org>
References: <4C2744E8AD2982428C5BFE523DF8CDCB49A488DAD8@MNEXMB1.qlogic.org>
 <adask52o9p6.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adask52o9p6.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Roland wrote: 
> I'm a little dubious about this.  We have an RMPP implementation in the kernel, and it seems 
> worthwhile to focus on stability and features there.  Allowing alternate RMPP implementations in 
> userspace seems a bit iffy -- we don't have a socket option that lets us do TCP in userspace for a 
> given connection, for example.

Sean wrote: 
> I agree with Roland's response on this.  I don't think we want to support a user space 
> implementation of RMPP.  The posted receive buffers are ultimately owned by the kernel, so it should 
> really control the windowing.  IMO, the other thread is showing that exposing simple things like as 
> timeouts, retries, and BUSY responses to the user leads to issues; exposing the full RMPP 
> implementation can't be better.

Hal wrote:

> I think the simplest change is to use rmpp_version 255 for this mode (and update doc/headers 
> accordingly) and preserve existing rmpp_version behavior.

We've redesigned the patch to comply with Hal's feedback, it would seem that Hal is ok with this basic approach.

First addressing Roland's comment, there are in fact TCP socket options which control how much buffering is done in the kernel and hence control message size and segmentation points for TCP.  Those options allow the careful balance of window size, kernel memory space and TCP performance to be tuned, the defaults for these options tend to be relatively small.  This is possible for TCP since the protocol is defined at the application level as a byte stream protocol, hence it is up to the TCP stack to decide the proper segmentation points and windowing.  Applications must be written to assume a recv() could return only part of a corresponding send() and could be at any arbitrary byte boundary.

Unfortunately for IB the size of an RMPP response and buffer cannot be controlled by the kernel.  So if an application has a large response to send, the entire buffer must be copied into the kernel and the kernel cannot decide on its own segmentation boundaries.  Hence the ability for selected management applications to control and limit the amount of kernel memory space is desirable.  These issues become serious at scale when larger RMPP responses are needed and more clients may also be issuing requests.  The two can combine and result in N^2 types behavior for kernel memory footprint relative to N=cluster node count or potentially N=cluster CPU core count.

To explain this, let's look at some basic RMPP queries.  An end node may issue an RMPP query to a centralized entity.  The size of this response can be a function of number of nodes.  Let's assume the response had 100 bytes per node.  At 1000 nodes, this response would be 100KB.  In this case the present OFED RMPP mechanism would transfer the full 100KB into the kernel and then process RMPP out of that kernel copy.  Now consider the fact that many nodes, perhaps even all, may want to issue queries at roughly the same time.  In this case 1000 nodes could each have 100KB responses active, in which case there would be 100MB of RMPP data stored in the kernel.  If this same example is expanded to 2000 nodes, the memory requirement grows to 400MB.  At 4000 nodes it's 1.6GB.  etc.  Other factors 
 can make this even worse, for example if a given node could issue multiple queries (1 per process), etc.

Granted this is an extreme example.  However use of such large amounts of kernel memory tends to be a serious issue.  This is made worse by the fact the management application also may need a copy of the response to facilitate error handling, etc.  In the applications I mention below, they were able to take advantage of data patterns in the responses to provide RMPP packets directly out of a single copy of the response/database.  In which case by managing the RMPP protocol directly they were able to use the single copy to provide each window size worth of packets.  In the 4000 node example this saved over 3 GB of RAM (1.6GB in kernel and 1.6GB-100KB in application).  Saving this much ram greatly reduced swapping, avoided excessive kernel footprint, and significantly improved the applicatio
 n performance.

For any centralized management application that uses RMPP, the present OFED approach will suffer from this issue.

Rather than require applications with these unique requirements to invent new RMPP-like protocols on special QPs, it seems reasonable to allow applications with special scaling needs to leverage the RMPP protocol standard but have control over the kernel buffering and ack handling.

The approach we are proposing accomplishes this requirement while maintaining backward compatibility and limiting the scope of ib_mad changes.  The exposure of RMPP implementation issues is limited to applications which choose to use this approach, and only applications needing such advanced capabilities would even attempt to do so.  This is unlike the timeout discussion where all applications are required to select timeouts and retry counts and most, unfortunately, give limited thought to such values and often only pick values which are appropriate to the small clusters in which the development was done.

As we indicated, there are two primary reasons for our implementation of this change.

>There are QLogic customers who have requested the ability to perform 
>RMPP transaction handling in user space.  This was an option in our old 
>proprietary stack and there are a few customers still using it which 
>need a way to forward migrate to OFED while containing the scope of 
>their application changes.  While we have developed appropriate "shim" libraries to allow their applications to migrate, we can't simulate/shim rmpp processing without some kernel support.

The customers in point have had this exact issue and implemented techniques in their applications to manage the RMPP transactions.  The old QLogic stack supported this capability and the user's needed to take advantage of it.  To further propagate OFED adoption we see it as desirable to permit the customer to migrate these applications easily and in a timely manner.

>We also have some management applications which also need these 
>capabilities.  For those applications, the use of application RMPP 
>control allows the application to perform some pacing of the RMPP 
>transactions, permits some parts of the RMPP response to be built on the fly and also permits a degree of sharing of the response data between multiple requestors.

We too have run into the exact same issue with our own management applications and have seen that the OFED approach can lead to large memory footprint, timeouts and other issues.

Since the servicing of RMPP requests is typically limited to a small number of nodes, one compromise might be to have a config option to enable/disable the feature.  In this way only management nodes would have the feature enabled and other ULPs and applications would hence be discouraged from using it.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
