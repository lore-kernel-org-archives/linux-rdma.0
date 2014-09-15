From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH v2 3/4] rsockets: distribute completion queue vectors
 among multiple cores
Date: Mon, 15 Sep 2014 11:06:03 +0200
Message-ID: <5416ABFB.7040701@acm.org>
References: <f028f54b9900ee34fcd1abd1d90d10e6@imap.linux.ibm.com> <5409DB0D.6080103@acm.org> <850a2835b5917f6da62af3d1ea0288fd@imap.linux.ibm.com> <540D50E9.5050709@acm.org> <a8ac21f3c9d7c802ab089bc0d432e40b@imap.linux.ibm.com> <540DF3CC.1060304@acm.org> <edc2b05703209d2a7626a31abb170ceb@imap.linux.ibm.com> <ef556922e7b766360a38df904dff1c70@imap.linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ef556922e7b766360a38df904dff1c70-FJGp5E75HVmZamtmwQBW5tBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sreedhar Kodali <srkodali-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 09/11/14 14:34, Sreedhar Kodali wrote:
> I have sent the revised patch v4 that groups and assigns comp vectors
> per process as you suggested.  Please go through it.

Shouldn't there be agreement about the approach before a patch is 
reworked and reposted ? I think the following aspects deserve wider 
discussion and agreement about these aspects is needed before the patch 
itself is discussed further:
- Do we need to discuss a policy that defines which completion vectors 
are associated with which CPU sockets ? Such a policy is needed to allow 
RDMA software to constrain RDMA completions to a single CPU socket and 
hence to avoid inter-socket cache misses. One possible policy is to 
associate an equal number of completion vectors with each CPU socket. If 
e.g. 8 completion vectors are provided by an HCA and two CPU sockets are 
available then completion vectors 0..3 could be bound to the CPU socket 
with index 0 and vectors 4..7 could be bound to CPU socket that has been 
assigned index 1 by the Linux kernel.
- Would it be useful to modify the irqbalance software such that it 
becomes aware of HCA's that provide multiple MSI-X vectors and hence 
automatically applies the policy mentioned in the previous bullet ?
- What should the default behavior be of the rsockets library ? Keep the 
current behavior (use completion vector 0), select one of the available 
completion vectors in a round-robin fashion or perhaps yet another policy ?
- The number of completion vectors provided by a HCA can change after a 
PCIe card has been added to or removed from the system. Such changes 
affect the number of bits of the completion mask that are relevant. How 
to handle this ?
- If a configuration option is added in the rsockets library to specify 
which completion vectors a process is allowed to use, should it be 
possible to specify individual completion vectors or is it sufficient if 
CPU socket numbers can be specified ? That last choice has the advantage 
that it is independent of the exact number of completion vectors that 
has been allocated by an HCA.
- How to cope with systems in which multiple RDMA HCA's are present and 
in which each HCA provides a different number of completion vectors ? Is 
a completion vector bitmask a proper means for such systems to specify 
which completion vectors should be used ?
- Do we need to treat virtual machine guests and CPU hot-plugging 
separately or can we rely on the information about CPU sockets that is 
provided by the hypervisor to the guest ?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
