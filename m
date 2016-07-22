From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v2 0/9] SELinux support for Infiniband RDMA
Date: Fri, 22 Jul 2016 16:02:59 +0000
Message-ID: <AM4PR0501MB22572EC9A6719DD910134F13C40A0@AM4PR0501MB2257.eurprd05.prod.outlook.com>
References: <1468537011-20407-1-git-send-email-danielj@mellanox.com>
 <CAHC9VhRuSSdUEdA65KBbt50fkDAjd+vATagNhXN9dYojNNBFSw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <selinux-bounces-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
Content-Language: en-US
List-Post: <mailto:selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
List-Help: <mailto:selinux-request-+05T5uksL2qpZYMLLGbcSA@public.gmane.org?subject=help>
Errors-To: selinux-bounces-+05T5uksL2qpZYMLLGbcSA@public.gmane.org
Sender: "Selinux" <selinux-bounces-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
To: Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org" <chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org" <selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, "sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/22/2016 10:46 AM, Paul Moore wrote:
> On Thu, Jul 14, 2016 at 6:56 PM, Dan Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>> From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>
>> The selinux next tree is missing some patches for IB/core.  This series
>> applies cleanly to ib-next, and should apply cleanly to selinux-next once
>> the IB patches are merged.
> Hi Dan,
>
> Thanks for the updated patchset, I'm taking a look at it today.  I do
> have one question, related but independent to your patches: is there a
> way to test the LSM controlled portions of the Infiniband stack
> without any IB hardware (e.g. is there an IB "loopback" device)?  I'm
> asking because we are really trying to make sure we have tests for any
> new code/functionality we add to SELinux, and requiring IB hardware to
> test the IB access controls would make this difficult.
>
> * https://github.com/SELinuxProject/selinux-testsuite
>
> -Paul
>
I found this: https://github.com/nminoru/pib but haven't used it.  I'll try playing with it and see if it can serve this purpose.



_______________________________________________
Selinux mailing list
Selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org
To unsubscribe, send email to Selinux-leave-+05T5uksL2pAGbPMOrvdOA@public.gmane.org
To get help, send an email containing "help" to Selinux-request-+05T5uksL2pAGbPMOrvdOA@public.gmane.org
