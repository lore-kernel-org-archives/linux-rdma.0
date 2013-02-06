From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH for 3.8 v3, resend 0/3] IB/SRP patches for kernel 3.8
Date: Wed, 06 Feb 2013 08:59:11 +0100
Message-ID: <51120D4F.2070102@acm.org>
References: <510BDCAA.204@acm.org> <CAJZOPZLKQV0QvrW5sK8hQJf7AZc+1nUzp+5YCkZ3iVU4oTWbLg@mail.gmail.com> <5111327F.6050402@acm.org> <CAJZOPZ+-Zg=jnqg4ZmFL5Yo4_2DoWGcgy=3u6g3Rf9y80pXnpg@mail.gmail.com> <5112049B.8030406@acm.org> <511209E5.1010807@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <511209E5.1010807-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 02/06/13 08:44, Or Gerlitz wrote:
> On 06/02/2013 09:22, Bart Van Assche wrote:
>>
>> A huge number of patches have been taken upstream between 3.8-rc1 and
>> 3.8-rc6. I have retested these three patches with 3.8-rc6 and would
>> appreciate if you would also repeat your tests.
>
> not really... this is what I see on Linus tree for the relevant
> directories, anywhere else I need to look
>
> linux-2.6]# git log --oneline v3.8-rc1..v3.8-rc6 drivers/scsi/
> drivers/block/ block/drivers/infiniband/ulp/srp
> bdb0ae6 Merge branch 'x86-urgent-for-linus' of
> git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> 83e6818 efi: Make 'efi_enabled' a function to query EFI facilities
> 2263647 Merge tag 'fixes-for-linus' of
> git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux
> 8d85fce Drivers: block: remove __dev* attributes.
> 6f03979 Drivers: scsi: remove __dev* attributes.
> f4953fe virtio-blk: Don't free ida when disk is in use

Hello Or,

Nobody outside Mellanox has ever been able to reproduce the behavior 
reported by you. Something in your tests might have been specific to the 
Mellanox environment. Have you perhaps been running your tests with a 
firmware version that is not available to the general public ? I would 
appreciate it if you could check your test environment and repeat your 
tests.

Thanks for your understanding,

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
