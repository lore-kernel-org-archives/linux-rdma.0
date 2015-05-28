From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v4 for-next 07/14] IB/core: GID attribute should be returned
 from verbs API and cache API
Date: Thu, 28 May 2015 19:34:36 +0300
Message-ID: <5567439C.7080700@mellanox.com>
References: <1432045637-9090-1-git-send-email-matanb@mellanox.com>
 <1432045637-9090-8-git-send-email-matanb@mellanox.com>
 <20150519180649.GC18675@obsidianresearch.com>
 <CAAKD3BAifeMcHbDwcaK7F6cjj=mAn3W0Ms2mOmoXDhaquFqKTA@mail.gmail.com>
 <20150520181718.GD28496@obsidianresearch.com>
 <CAAKD3BDJtpEhfhsB=o4hc=ARWMt7JgpqvbjXJVvsL_vLZRn8yQ@mail.gmail.com>
 <20150528160748.GC2962@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150528160748.GC2962-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 5/28/2015 7:07 PM, Jason Gunthorpe wrote:
>> Patch 8 (the ndev part) is relevant. GID is now related to a ndev and
>> >we would like
>> >to expose this information to the user.
>> >In non rdma-cm applications, how would a user select the gid_index he wants?
> I don't mean drop forever, I mean, concentrate on getting this clean
> up done, then start discussing UAPI changes separately. Please don't
> bury UAPI changes, new features, etc in a cleanup patch series.

Jason,

I agree. This series can be perfectly made without UAPI changes, Matan 
can drop patch #8 and have user-space to just work as they did before, 
for both librdmacm and libibverbs consumers.

As for the RoCE GID table itself, adding in properly net-devices in 
their native Linux kernel form, namely with if_index and name-space -- 
seems to me the correct way to go. This for itself goes just a bit 
beyond refactoring, doesn't add special complexity which wasn't there 
before and has the advantage of doing things right and solid.

Or.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
