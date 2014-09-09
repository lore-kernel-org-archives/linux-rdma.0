From: Sreedhar Kodali <srkodali-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v2 3/4] rsockets: distribute completion queue vectors
 among multiple cores
Date: Tue, 09 Sep 2014 17:58:26 +0530
Message-ID: <edc2b05703209d2a7626a31abb170ceb@imap.linux.ibm.com>
References: <f028f54b9900ee34fcd1abd1d90d10e6@imap.linux.ibm.com>
 <5409DB0D.6080103@acm.org>
 <850a2835b5917f6da62af3d1ea0288fd@imap.linux.ibm.com>
 <540D50E9.5050709@acm.org>
 <a8ac21f3c9d7c802ab089bc0d432e40b@imap.linux.ibm.com>
 <540DF3CC.1060304@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <540DF3CC.1060304-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 2014-09-08 23:52, Bart Van Assche wrote:
> On 09/08/14 16:27, Sreedhar Kodali wrote:
>> Thanks for your insights.  Your suggestion of having a separate
>> vector per process is really useful when multiple processes are
>> simultaneously running in the same environment.  At the implementation
>> level this requires an extended configuration file format. Can't
>> we possibly think of this as a next iteration?
> 
> This patch introduces a new configuration file
> (/etc/rdma/rsocket/comp_vector). User expect that such configuration
> files remain supported after a software upgrade. In other words,
> introduction of a new configuration file deserves careful
> consideration. Do we really need this new configuration file ? Why not
> e.g. to change the default behavior of the rsockets library into
> spreading the interrupt processing workload over all completion
> vectors supported by the HCA ? Furthermore, the number of completion
> vectors that is supported by an HCA not only depends on the HCA
> firmware but also on the number of completion vectors a HCA could
> allocate during driver initialization. The number of MSI-X vectors
> available on an x86-64 system is limited (224). Dual-socket x86-64
> motherboards with up to 11 PCIe slots are available commercially. If
> all PCIe-slots are populated it's almost sure that one of the PCIe
> cards won't be assigned as many MSI-X vectors as it could use.
> 
> Sorry but I'm not convinced that using the same completion vector mask
> for all HCA's and all processes is a good idea. Or is there perhaps
> something I have overlooked ?
> 
> Bart.

Hi Bart,

I agree with your suggestions - working on the revised patch 
accordingly.

Thank You.

- Sreedhar

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
