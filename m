From: Leon Romanovsky <leon@leon.nu>
Subject: Re: [PATCH] fix return value error
Date: Wed, 14 Oct 2015 17:29:32 +0300
Message-ID: <CALq1K=+x-+4Hhfg9N7fXdj-A1c12Z55SC4CiSy6yD2G_77yE6Q@mail.gmail.com>
References: <1444808810-29995-1-git-send-email-os@iscas.ac.cn> <32E1700B9017364D9B60AED9960492BC25985427@fmsmsx120.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <32E1700B9017364D9B60AED9960492BC25985427@fmsmsx120.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
Cc: Heloise NH <os@iscas.ac.cn>, "dledford@redhat.com" <dledford@redhat.com>, "Hefty, Sean" <sean.hefty@intel.com>, "hal.rosenstock@gmail.com" <hal.rosenstock@gmail.com>, "Or Gerlitz (gerlitz.or@gmail.com)" <gerlitz.or@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 14, 2015 at 5:17 PM, Marciniszyn, Mike
<mike.marciniszyn@intel.com> wrote:
>> > Subject: [PATCH] fix return value error
>> >
>>
>> I checked returns in configfs (-ENOMEM), proc (-ENOENT), proc-sys (-
>> ENOMEM), ramfs (-ENOSPC), vfs (-ENOMEM).
>>
>> Not entirely consistent but this matches the majority.
>>
>> I agree -EPERM is pretty misleading.
>>
>> Acked-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
>
> Thanks Or on catching the bad directory in the patch.
Thanks Or

>
> Doug, can you fix this up or do you want it resubmitted?
>
> Mike
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
