From: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: =?UTF-8?Q?Re:_=e3=80=90For_help=e3=80=91_some_tips_for_upstream_the?=
 =?UTF-8?Q?_userspace_driver_code_of_hns=5froce?=
Date: Fri, 14 Oct 2016 15:24:37 +0800
Message-ID: <58008835.3060403@huawei.com>
References: <57FF414A.3000200@huawei.com> <20161013093659.GA9282@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161013093659.GA9282-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linuxarm <linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi, Leon
  I have learned the guide and I am working it.
  I have learned the README.md in the branch of rdma-core.
  According to the instruction for building the user-space stack, it only
  support to build in Debian/Fedora/OpenSuSE/centos and ubuntu is not?

thanks

在 2016/10/13 17:36, Leon Romanovsky 写道:
> On Thu, Oct 13, 2016 at 04:09:46PM +0800, oulijun wrote:
>> Hi, Doug Ledford
>>    Now, I am preparing for upstreaming the userspace driver code of hns_roce.  But, we have
>> some difficulty how to upstream it. for example,
>>    i) which branch of ofed should we upstream ?
>>    ii) if want to upstream the userspace driver of hns_roce successfully, how we should do?
>>
>>   Can you give me some guides?
> 
> Hi Lijun,
> 
> Our main library for all user-space stack is located at github [1].
> Please see similar question from Ram [2] and Jason's response [3] to it.
> 
> [1] github.com/linux-rdma/rdma-core
> [2[ http://marc.info/?l=linux-rdma&m=147574131706820&w=2
> [3] http://marc.info/?l=linux-rdma&m=147577168016989&w=2
> 
> Thanks.
> 
>>
>> thanks
>> Lijun Ou
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
