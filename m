From: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [ofa-general][PATCH 3/4] SRP fail-over faster
Date: Thu, 15 Oct 2009 09:23:36 -0700
Message-ID: <4AD74C88.8030604@mellanox.com>
References: <4AD3B453.3030109@mellanox.com> <ada1vl5alqh.fsf@cisco.com>	 <4AD63681.6080901@mellanox.com> <adaljjd8zrj.fsf@cisco.com>	 <4AD63DB1.3060906@mellanox.com>  <adahbu18uf5.fsf@cisco.com> <1255570760.13845.4.camel@obelisk.thedillows.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1255570760.13845.4.camel-1q1vX8mYZiGLUyTwlgNVppKKF0rrzTr+@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

David Dillow wrote:
> On Wed, 2009-10-14 at 15:47 -0700, Roland Dreier wrote:
>   
>>>>  > First it does not make sense for user to set it below 60; therefore,
>>>>         
>>  > >  > it is forced to have 60 and above
>>
>>  > > Why not?  A minute seems to be a really long time given the point of
>>  > > these patches is supposed to be failing over faster.  Surely we can tell
>>  > > if a path really failed sooner than 60 seconds on an IB fabric.
>>
>>  > When we fail-over, it will cause the luns ownership transfer in
>>  > target/storage. It's undesirable op unless necessary
>>  > Target/storage most likely can reboot and come back within 60 seconds
>>  > We don't want to create the situation of path bouncing
>>
>> OK, I can see why in some (many) situations it makes sense to wait a
>> while before reporting a target as gone.  But why do we hard code the
>> policy of a minimum timeout of 60 seconds in the kernel?  Why not a
>> minimum of 120 seconds?  What if I know my storage is guaranteed to
>> reboot in 2 seconds -- why can't I have a timeout of 5 seconds?
>>
>> You haven't really explained where the magic number of 60 seconds comes from.
>>     
>
> On that note, does this have to be a module parameter -- what if I have
> connections to different devices, that have different reboot guarantees?
>
>   
It can be tuned down to target/device level instead of  module parameter.
What do you think, Roland? It can be a param. in login string and stored 
in target structure.
> And if I really want a timeout of less than 60 seconds, why should I
> have to patch my kernel?
>
>   
Then target parameter would be the right approach.
> And if I want to disable this completely?
>   

Unless these patches are bad and affect the stability of the driver, why 
do you want to disable it? If you don't use multipath/device-mapper and 
use /dev/sd**, everything will be  same


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
