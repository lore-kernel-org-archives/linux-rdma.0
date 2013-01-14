From: Ido Shamai <idos-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: Distributing IPoIB interrupts
Date: Mon, 14 Jan 2013 18:55:11 +0200
Message-ID: <50F4386F.2090208@dev.mellanox.co.il>
References: <CAPb9-SHHoBbYfKSzwck45j3HzXUVoo73fffAafBMexn7riff2g@mail.gmail.com> <50F13104.5070407@dev.mellanox.co.il> <50F13830.8080309@dev.mellanox.co.il> <CAPb9-SHb=ZrZ5PB6NLH+tVFzYR=qzqV48GqVfEmrMMVEZZG-+w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAPb9-SHb=ZrZ5PB6NLH+tVFzYR=qzqV48GqVfEmrMMVEZZG-+w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christopher Mitchell <christopher-1z5WdJkP5Frk1uMJSBkQmQ@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 1/12/2013 6:52 PM, Christopher Mitchell wrote:
> Ido,
>
> These are dual-processor AMD Opteron systems with 8 physical cores per
> processor. I have libibverbs 1.1.6-1ubuntu1, libmlx4-1.0.4, and
> librdmacm 1.0.15-1 and friends, which appears to correspond to OFED
> 3.2 (cf. http://www.openfabrics.org/downloads/OFED/release_notes/OFED_3.2_rc1_release_notes).
> I misspoke: these are ConnectX-2, not 3, HCAs. Does that change
> anything?
Right.

Although in IPoIB case, those libraries are not taken in action, since 
it uses the ib_ipoib module in the kernel.
> Thanks in advance,
> Christopher
>
> On Sat, Jan 12, 2013 at 5:17 AM, Ido Shamai <idos-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
>> On 1/12/2013 11:46 AM, Ido Shamai wrote:
>>
>> On 1/11/2013 10:48 PM, Christopher Mitchell wrote:
>>
>> Hi,
>>
>> Hi Christopher,
>>
>> Which OFED version is being used in this case?
>> Are those Sandy Brdige PCIx gen3 systems?
>>
>> The required technique is basically what you've described.
>> Assuming Sandy Bridge:
>>
>> Find out which CPU NUMA node ConnectX3 sits on (for dual socket systems).
>> Spread IPoIB interrupts (their names depends on OFED version usually
>> something with mlx) onto cores of this node.
>> Run test application affinity on those nodes as well.
>> This way you should the maximum out of your system.
>>
>> One of my colleagues has been trying to benchmark the maximum
>> performance of Mellanox ConnectX-3 Infiniband cards using IP over IB.
>> He was able to use smp_affinity to distribute Ethernet packet-receive
>> interrupts across many cores, and specify on which cores the
>> interrupts occurred. With IPoIB, smp_affinity successfully moved
>> interrupts to a specific core, but he was unable to distribute the
>> IPoIB interrupts onto multiple cores. Is there a design detail of how
>> IPoIB works that prevents this? Does anyone know of a setting,
>> configuration value, or feature that we're overlooking to allow this,
>> or is it impossible? Thanks in advance for your feedback.
>>
>> Sincerely,
>> Christopher
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
