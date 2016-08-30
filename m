From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v3 0/9] SELinux support for Infiniband RDMA
Date: Tue, 30 Aug 2016 14:06:53 +0000
Message-ID: <VI1PR0501MB242949202A1DA23E5C8E1E8AC4E00@VI1PR0501MB2429.eurprd05.prod.outlook.com>
References: <1469800416-125043-1-git-send-email-danielj@mellanox.com>
 <CAHC9VhS1Tg3qr2Nncd_eq_eUXrf-wMickoeoF978Q7L+gN7J1g@mail.gmail.com>
 <VI1PR0501MB24297FF784A085DC0AAE2C1EC4E10@VI1PR0501MB2429.eurprd05.prod.outlook.com>
 <CAHC9VhTEOvZ76dNJp35WEhr+r84eZZ6_ZmuaznGLakzZGcXhUw@mail.gmail.com>
 <20160830074607.GN594@leon.nu>
 <CAHC9VhRUmbsuV40rRpG+LeNUgY7rVqOkt-fxTMAFDRRdLvEkug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <selinux-bounces-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
Content-Language: en-US
List-Post: <mailto:selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
List-Help: <mailto:selinux-request-+05T5uksL2qpZYMLLGbcSA@public.gmane.org?subject=help>
Errors-To: selinux-bounces-+05T5uksL2qpZYMLLGbcSA@public.gmane.org
Sender: "Selinux" <selinux-bounces-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
To: Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org" <chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org" <selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, "sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 8/30/2016 8:53 AM, Paul Moore wrote:
> On Tue, Aug 30, 2016 at 3:46 AM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>> On Mon, Aug 29, 2016 at 08:00:32PM -0400, Paul Moore wrote:
>>> On Mon, Aug 29, 2016 at 5:48 PM, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>>>> On 8/29/2016 4:40 PM, Paul Moore wrote:
>>>>> On Fri, Jul 29, 2016 at 9:53 AM, Dan Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>>>>>> From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>>>> ...
>>>>>
>>>>>> Daniel Jurgens (9):
>>>>>>   IB/core: IB cache enhancements to support Infiniband security
>>>>>>   IB/core: Enforce PKey security on QPs
>>>>>>   selinux lsm IB/core: Implement LSM notification system
>>>>>>   IB/core: Enforce security on management datagrams
>>>>>>   selinux: Create policydb version for Infiniband support
>>>>>>   selinux: Allocate and free infiniband security hooks
>>>>>>   selinux: Implement Infiniband PKey "Access" access vector
>>>>>>   selinux: Add IB Port SMP access vector
>>>>>>   selinux: Add a cache for quicker retreival of PKey SIDs
>>>>> Hi Daniel,
>>>>>
>>>>> My apologies for such a long delay in responding to this latest
>>>>> patchset; conferences, travel, and vacation have made for a very busy
>>>>> August.  After you posted the v2 patchset we had an off-list
>>>>> discussion regarding testing the SELinux/IB integration; unfortunately
>>>>> we realized that IB hardware would be needed to test this (no IB
>>>>> loopback device), but we agreed that having tests would be beneficial.
>>>>>
>>>>> Have you done any work yet towards adding SELinux/IB tests to the
>>>>> selinux-testsuite project?
>>>>>
>>>>> * https://github.com/SELinuxProject/selinux-testsuite
>>>> Hi Paul, I've not started doing that yet.  I've been waiting for feedback of any kind from the RDMA list.  I thought the test updates would be more appropriate around the time I'm submitting the changes to the user space utilities to allow labeling the new types.
>>> Okay, no problem.  I just want the tests in place and functional when
>>> we merge the kernel code.
>> Hi Paul,
>>
>> IMHO, you can use Soft RoCE (RXE) [1] for it.
>>
>> ----
>> Soft RoCE (RXE) - The software RoCE driver
>>
>> ib_rxe implements the RDMA transport and registers to the RDMA core
>> device as a kernel verbs provider. It also implements the packet IO
>> layer. On the other hand ib_rxe registers to the Linux netdev stack
>> as a udp encapsulating protocol, in that case RDMA, for sending and
>> receiving packets over any Ethernet device.  This yields a RDMA
>> transport over the UDP/Ethernet network layer forming a RoCEv2
>> compatible device.
>>
>> The configuration procedure of the Soft RoCE drivers requires
>> binding to any existing Ethernet network device. This is done with
>> /sys interface.
>> ----
>>
>> [1]
>> https://git.kernel.org/cgit/linux/kernel/git/dledford/rdma.git/tree/drivers/infiniband/sw/rxe
> Hi Leon,
>
> It looks like v4.8 will have all the necessary pieces for this, yes?
> Is there any documentation on this other than the git log?  Keep in
> mind I'm looking at this from the SELinux side, I'm very Infiniband
> ignorant at the moment; although Daniel has been very patient in
> walking me through some of the basics.
>
> Daniel, does this look like something we might be able to use?
>
I don't this will be useful, RoCE doesn't have partitions/PKeys because it uses Ethernet as the transport instead of Infiniband. 


_______________________________________________
Selinux mailing list
Selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org
To unsubscribe, send email to Selinux-leave-+05T5uksL2pAGbPMOrvdOA@public.gmane.org
To get help, send an email containing "help" to Selinux-request-+05T5uksL2pAGbPMOrvdOA@public.gmane.org
