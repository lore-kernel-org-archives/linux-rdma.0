From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next 0/2] IB/{core,mlx4_ib}: RX/TX checksum offload
Date: Thu, 3 Sep 2015 09:22:55 +0300
Message-ID: <55E7E73F.7000905@mellanox.com>
References: <1438788867-18332-1-git-send-email-amirv@mellanox.com>
 <alpine.DEB.2.11.1509020930430.12270@east.gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.11.1509020930430.12270-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eric Dube <edube-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 9/2/2015 5:32 PM, Christoph Lameter wrote:
> On Wed, 5 Aug 2015, Amir Vadai wrote:
>
>> This will be used by a revised version of the IP checksum patches [1], that
>> will be sent later on.
> Ok when can we get the full set for testing? Seems that the libibverbs and
> libmlx4 portions are missing?

not accurate.

After this post, we have posted patched to libibverbs/libmlx4 on Aug 
17th, that require no kernel changes.

Please test these ones and skip this post for now and let us know how's 
going with them:

https://patchwork.kernel.org/patch/7025581/
https://patchwork.kernel.org/patch/7025611/

I copied the author,

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
