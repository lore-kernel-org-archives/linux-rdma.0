From: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [bug] build the user-space stack code in github is fail on ubuntu
Date: Mon, 17 Oct 2016 16:48:13 +0800
Message-ID: <5804904D.6050809@huawei.com>
References: <5800A467.2020602@huawei.com>
 <20161014164604.GC6258@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161014164604.GC6258-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linuxarm <linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

在 2016/10/15 0:46, Jason Gunthorpe 写道:
> On Fri, Oct 14, 2016 at 05:24:55PM +0800, oulijun wrote:
> 
>> ubuntu@62fe1357a077:~/rdma_core/rdma-core/build_1$ cmake ..
>> CMake Error at CMakeLists.txt:199 (message):
>>   Cannot find libnl-3.0 or libnl-1
> 
> There are directions in README.md you need to follow:
> 
> $ apt-get install build-essential cmake gcc libnl-3-dev libnl-route-3-dev ninja-build pkg-config valgrind
> 
> Jason
> 
> 
Thanks your guide, I have got it. it has works


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
