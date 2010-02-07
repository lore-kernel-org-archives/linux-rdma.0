From: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 0/8] ib/iser: major face lift of the data path code
Date: Sun, 07 Feb 2010 16:51:14 +0200
Message-ID: <4B6ED362.2060909@Voltaire.com>
References: <Pine.LNX.4.64.1002031721280.11944@zuben.voltaire.com>	<e2e108261002030811r5c740d6fr4cc055702a88aa50@mail.gmail.com>	<4B6AD7D5.7030204@Voltaire.com> <4B6C0C93.2090107@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B6C0C93.2090107-d+Crzxg7Rs0@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, Yaron Haviv <yaronh-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Vladislav Bolkhovitin wrote:
> Or Gerlitz wrote:

> From where did you get those latency numbers?

read iostat(8), you'll see that await is "The average time (in milliseconds) 
for I/O requests issued to the device to be served"

> what kind of test did you do?

I connected a Linux box through iser to a target exposing four "NULL luns", 
i.e luns which are not backed by real storage. I run four copies of disktest
each over a different lun, where each was reading 1k blocks, etc. 

Or.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
