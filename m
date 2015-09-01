From: Jim Davis <jim.epost@gmail.com>
Subject: Re: [PATCH] staging: ipath: fix build failure
Date: Tue, 1 Sep 2015 09:54:10 -0700
Message-ID: <CA+r1ZhjwFP4Odiy_dUnFWNtjuW0KEZeGY1ynx9kf-WScPbYvQA@mail.gmail.com>
References: <1441112498-22057-1-git-send-email-sudipm.mukherjee@gmail.com>
 <55E5BBC7.1020007@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <55E5BBC7.1020007@redhat.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Doug Ledford <dledford@redhat.com>
Cc: devel <devel@driverdev.osuosl.org>, linux-rdma <linux-rdma@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel <linux-kernel@vger.kernel.org>, Mike Marciniszyn <infinipath@intel.com>, Sudip Mukherjee <sudipm.mukherjee@gmail.com>
List-Id: linux-rdma@vger.kernel.org

On Tue, Sep 1, 2015 at 7:52 AM, Doug Ledford <dledford@redhat.com> wrote:
> On 09/01/2015 09:01 AM, Sudip Mukherjee wrote:
>> building of ipath depends on infiniband. And if ipath is selected and
>> infiniband is not then build fails with:
>> ERROR: "ib_alloc_device" [drivers/staging/ipath/ib_ipath.ko] undefined!
>> ERROR: "ib_dealloc_device" [drivers/staging/ipath/ib_ipath.ko] undefined!
>> ERROR: "ib_dispatch_event" [drivers/staging/ipath/ib_ipath.ko] undefined!
>> ERROR: "ib_register_device" [drivers/staging/ipath/ib_ipath.ko] undefined!
>> ERROR: "ib_unregister_device" [drivers/staging/ipath/ib_ipath.ko] undefined!
>> ERROR: "ib_modify_qp_is_ok" [drivers/staging/ipath/ib_ipath.ko] undefined!
>> ERROR: "ib_wq" [drivers/staging/ipath/ib_ipath.ko] undefined!
>>
>> Config at: https://lkml.org/lkml/2015/8/31/328
>>
>> Reported-by: Jim Davis <jim.epost@gmail.com>
>> Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
>> ---
>>  drivers/staging/ipath/Kconfig | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/staging/ipath/Kconfig b/drivers/staging/ipath/Kconfig
>> index 041ce06..1edc21b 100644
>> --- a/drivers/staging/ipath/Kconfig
>> +++ b/drivers/staging/ipath/Kconfig
>> @@ -1,6 +1,7 @@
>>  config INFINIBAND_IPATH
>>       tristate "QLogic HTX HCA support"
>>       depends on 64BIT && NET && HT_IRQ
>> +     depends on INFINIBAND
>>       ---help---
>>       This is a driver for the deprecated QLogic Hyper-Transport
>>       IB host channel adapter (model QHT7140),
>>
>
> The ipath driver was moved to staging/rdma/ipath and has proper
> protection against being built without the InfiniBand subsystem.  Where
> are you seeing this tree?  I'm curious because I no longer have this
> driver in this location in my tree and I never pushed it anywhere other
> than one of my trees.  Is this maybe in linux-next?

Yes; http://marc.info/?l=linux-kernel&m=144104080331664&w=3
-- 
Jim
