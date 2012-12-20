From: Vipul Pandya <vipul@chelsio.com>
Subject: Re: linux-next: build failure after merge of the infiniband tree
Date: Thu, 20 Dec 2012 15:28:16 +0530
Message-ID: <50D2E138.7000700@chelsio.com>
References: <20121220094433.791d70e55ae5e3325a6190fc@canb.auug.org.au> <CAG4TOxPVc0tNeLhi3FF=K_UJpizh2OZgviT5WqqLvZsg-QEoNw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAG4TOxPVc0tNeLhi3FF=K_UJpizh2OZgviT5WqqLvZsg-QEoNw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org



On 20-12-2012 05:52, Roland Dreier wrote:
> On Wed, Dec 19, 2012 at 2:44 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> Hi all,
>>
>> After merging the infiniband tree, today's linux-next build (x86_64_
>> allmodconfig) failed like this:
>>
>> In file included from drivers/scsi/csiostor/csio_wr.h:42:0,
>>                  from drivers/scsi/csiostor/csio_scsi.h:49,
>>                  from drivers/scsi/csiostor/csio_init.h:45,
>>                  from drivers/scsi/csiostor/csio_attr.c:45:
>> drivers/scsi/csiostor/t4fw_api_stor.h:43:6: error: nested redefinition of 'enum fw_retval'
>> drivers/scsi/csiostor/t4fw_api_stor.h:43:6: error: redeclaration of 'enum fw_retval'
>> drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h:42:6: note: originally defined here
>> drivers/scsi/csiostor/t4fw_api_stor.h:48:2: error: redeclaration of enumerator 'FW_ENOEXEC'
>> drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h:39:2: note: previous definition of 'FW_ENOEXEC' was here
>> drivers/scsi/csiostor/t4fw_api_stor.h:50:2: error: redeclaration of enumerator 'FW_ENOMEM'
>> drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h:43:2: note: previous definition of 'FW_ENOMEM' was here
>> drivers/scsi/csiostor/t4fw_api_stor.h:58:2: error: redeclaration of enumerator 'FW_EADDRINUSE'
>> drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h:44:2: note: previous definition of 'FW_EADDRINUSE' was here
>>
>> And several others similar.
>>
>> Caused by commit f65b56b15931 ("RDMA/cxgb4: Fix LE hash collision bug for
>> active open connection").
> 
> 
> Vipul, is the right fix to pull the full list of FW return values from
> t4fw_api_stor.h into t4fw_api.h as part of this patch (f65b56b15931)?
> 

Yes, this is a correct way to fix this issue. I see that this change is
already done. Thanks for providing the fix.
