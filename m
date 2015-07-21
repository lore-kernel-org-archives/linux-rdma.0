From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: RFC: Immediate data support for SRP
Date: Mon, 20 Jul 2015 17:03:06 -0700
Message-ID: <55AD8C3A.9070403@sandisk.com>
References: <55A7CCF1.3080201@sandisk.com>
 <55ABCB34.1000506@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55ABCB34.1000506-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 07/19/2015 09:07 AM, Sagi Grimberg wrote:
> On 7/16/2015 6:25 PM, Bart Van Assche wrote:
>> As you probably know for write requests "immediate data" means sending
>> the data in the same packet as the write command instead of sending it
>> as a separate packet. This approach improves performance and reduces
>> latency. Although support for immediate data has not been standardized,
>
> Has anyone tried to get it into the standard? It would seem beneficial
> to just add it. I wouldn't want this to be a Linux compatible only
> feature...

Earlier today I have asked the SanDisk representative in the ANSI T10 
committee for his opinion about standardizing support for immediate data 
for the SRP protocol. I'm now waiting for his reply.

>> it is easy to add to the SRP initiator and target drivers.
>> Implementations exist in the ib_srp-backport initiator driver and the
>> SCST SRP target driver (see also
>> https://github.com/bvanassche/ib_srp-backport and
>> http://sourceforge.net/p/scst/svn/HEAD/tree/trunk/srpt/). These
>> implementations are available since considerable time, work reliably,
>> are backwards compatible and support zero-copy. Since using immediate
>> data provides a measurable performance improvement I'm wondering whether
>> it would be acceptable to add support for immediate data to the SRP
>> drivers in the Linux kernel tree (ib_srp and ib_srpt) ?
>
> Was this tested against any other array besides SCST and LIO? I know
> people are using SRP against various arrays (Oracle ZFS, RamSan TMS,
> DDN Fusion, NIMBUS, NetApp E5400A...). Their not running upstream
> kernels, but they will catch up at some point...

Not yet, but the existing implementation is backwards compatible. The 
SRP initiator sets a flag in the login request to request the target 
driver to enable immediate data (SRP_BUF_FORMAT_IMM), and only if the 
target driver sends a login response in which the same flag is set 
immediate data is enabled. Immediate data could only be enabled when it 
should not be enabled if an SRP target sets other flags in its login 
reply than those that have been standardized by the ANSI T10 committee.

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
