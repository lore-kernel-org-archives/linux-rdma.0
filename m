From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V1 rdma-core 0/2] Optimize RoCE address handle creation
 for userspace
Date: Tue, 6 Dec 2016 00:01:13 +0200
Message-ID: <7b8e90ac-c653-6a54-846d-75adeeb8059f@dev.mellanox.co.il>
References: <1480866806-5052-1-git-send-email-yishaih@mellanox.com>
 <20161205170702.GA27306@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161205170702.GA27306-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 12/5/2016 7:07 PM, Jason Gunthorpe wrote:
> On Sun, Dec 04, 2016 at 05:53:24PM +0200, Yishai Hadas wrote:
>
>> Test results:
>> Upon testing the above use case the provider couldn't be loaded as expected,
>> "libibverbs: Warning: couldn't load driver 'libmlx5-rdmav2.so':
>> libmlx5-rdmav2.so: cannot open shared object file: No such file or directory"
>
> The dynmic linker didn't print something too? That is surprising..

No more output, I was surprised as well about the error message, that's 
why I used strace to follow the system calls. Looking at the man page of 
dlopen can see that upon an error the most recent error is returned 
which was in that case ENOENT as the linker continued searching in other 
locations.

Just run with LD_LIBRARY_PATH=/usr/lib64/libibverbs which based on man 
page will cause the linker to look only in that location, I get below 
error as we expect it.

libibverbs: Warning: couldn't load driver 'libmlx5-rdmav2.so': 
/usr/lib64/libibverbs/libmlx5-rdmav2.so: symbol ibv_cmd_create_ah, 
version IBVERBS_1.0 not defined in file libibverbs.so.1 with link time 
reference

> I'm not sure where we are in the release cycle right now.. Doug - if
> we didn't make a release with the 1.3 symbol tag (this was created
> just before rdma-core) then this should go into 1.3 when it gets
> merged..

Jason,
You pointed to use 1.4, the series followed that.

Doug,
Can you please comment here ? we should have a clear definition what 
defined to be a "release" which requires a new number.
In case we want to use 1.3 please let me know if I need to re-spin or 
you will change as part of the merge.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
