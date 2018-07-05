From: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Subject: Re: general protection fault in rds_ib_get_mr
Date: Thu, 5 Jul 2018 09:09:44 -0700
Message-ID: <3bb47711-870e-90c6-d404-3fe61f0ab9a0@oracle.com>
References: <089e082ce58896ad350567ee4825@google.com>
 <20180513211058.GE677@sol.localdomain>
 <27665604-6a26-36e2-3a58-9c8b3d9eab80@oracle.com>
 <20180704213506.GH725@sol.localdomain>
 <04c882dc-332e-92d6-fe76-b1dd3bedd71c@oracle.com>
 <20180705070641.ske6jjvk4zp5kg2f@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180705070641.ske6jjvk4zp5kg2f@linux-x5ow.site>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Eric Biggers <ebiggers3@gmail.com>, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, syzbot <syzbot+b51c77ef956678a65834@syzkaller.appspotmail.com>, davem@davemloft.net, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
List-Id: linux-rdma@vger.kernel.org

On 7/5/2018 12:06 AM, Johannes Thumshirn wrote:
> On Wed, Jul 04, 2018 at 05:32:20PM -0700, santosh.shilimkar@oracle.com wrote:
>> On 7/4/18 2:35 PM, Eric Biggers wrote:
>>> On Sun, May 13, 2018 at 10:46:37PM -0700, santosh.shilimkar@oracle.com wrote:
>>>> On 5/13/18 2:10 PM, Eric Biggers wrote:
>>>>> On Wed, Mar 21, 2018 at 09:00:01AM -0700, syzbot wrote:
>>>>
>>>> [...]
>>>>
>>>>
>>>>> Still reproducible on Linus' tree (commit 66e1c94db3cd4) and linux-next
>>>>> (next-20180511).  Here's a simplified reproducer:
>>>>>
>>>> Thanks for the test case !!
>>>>
>>
>> [...]
>>
>>>
>>> Ping; this RDS bug is still unfixed.  The same reproducer I gave earlier still
>>> works, even when run as a non-root user.  I tested upstream commit
>>> fc36def997cfd6 (v4.18-rc3-113-gfc36def997cfd), and linux-next commit
>>> bce40927669338 (next-20180704).
>>>
>> Yeah I haven't sent a fix for this yet. Downstream we have refactored
>> MR code and I wanted to get that upstream. With that this bug will
>> also get addressed. I was hoping to get that series but since some
>> optimisation is still pending investigations its getting delayed.
>>
>> Will find out if I can fix this panic in meantime with smaller change.
>> Thanks for reminder.
> 
> Oh please sent bug fixes _before_ refactoring in that area. Otherwise
> it's a pain for everybody backporting the fix to a stable kernel.
> 
OK. we will look into it if an interim fix can be made....
