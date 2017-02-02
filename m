From: Yigal Korman <yigal-/8YdC2HfS5554TAoqtyWWQ@public.gmane.org>
Subject: Re: any suggested configuration for rxe?
Date: Thu, 2 Feb 2017 10:18:49 +0200
Message-ID: <CACTTzNbD7rU+DJLgCDnkZb5pSUEu+yvSfQc_WmQoAoPkOPyYvQ@mail.gmail.com>
References: <CAJ-uSQZcnQ+Mqj1XGuMSzP54WQi6KofDyp11dCog+bqGmL3MWA@mail.gmail.com>
 <CAG9sBKPj9wJhwZOFDXoOwH0=tBZR1pWdS6chYn_VK6SLdDQ7Xg@mail.gmail.com>
 <CAJ-uSQY50gRrQe7TAoJq3rd_MFqX8o=y_CZ=hqFJ1=WFZSg+tw@mail.gmail.com>
 <CAG9sBKPGWNrR_ejm-LxNzy5iqXKwvxUD2-mLYsGJnVw7FkxKHg@mail.gmail.com>
 <CAG9sBKMVVtUdffzH8DbS7vRzYiyAPDBn+n2MMBYvpe6SQXYHjA@mail.gmail.com>
 <CAJ-uSQb0jqewQL095i_+vtzCnPK70AnLE+XAgv_XkjxKW9jLFQ@mail.gmail.com> <CAG9sBKPERZ-8f2N-S7B4+HmgrF+1=VGmOXTTM7urQ4+DZSAmFw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG9sBKPERZ-8f2N-S7B4+HmgrF+1=VGmOXTTM7urQ4+DZSAmFw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: feu tche <feutche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 2, 2017 at 8:56 AM, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> On Thu, Feb 2, 2017 at 1:07 AM, feu tche <feutche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> hi Moni, guys,
>>
>> Sure yes I could ping, yes, no firewall or anything, in all cases that
>> was clean minimal install of Ubuntu 16.04.1 with updates and 4.9.6
>> kernel.
>> In my previous tests that was all on vmware vms on virtual network,
>> but as you asked I also decided to check on real hardware.
>>
>> I've got same results (below) between two machines with dual Intel
>> I350 and I also checked same both directions against a machine with
>> dual Mellanox ConnectX-3 Pro.
>>
> I will try to bring up the same setup here and see how it goes.
> thanks for the report

[resend in plaintext]

Hi, I have the same issue on 4.9 with libvirt using qemu/kvm (nic is
virtio_net).
Let me know if you need any info from me on reproducing this.

Thanks,
Yigal

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
