From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: rdmacm-utils: Missing man pages for cmtime and udpong
Date: Fri, 28 Apr 2017 10:18:15 -0400
Message-ID: <550f6e6a-931a-0aba-2d54-1ca1b3a44150@dev.mellanox.co.il>
References: <1493040510.17795.3.camel@profitbricks.com>
 <20170425180423.GT14088@mtr-leonro.local>
 <1493198562.3837.2.camel@profitbricks.com>
 <20170427040018.GY14088@mtr-leonro.local>
 <1493370517.3837.9.camel@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1493370517.3837.9.camel-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, List Linux RDMA Mailing <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 4/28/2017 5:08 AM, Benjamin Drung wrote:
> Am Donnerstag, den 27.04.2017, 07:00 +0300 schrieb Leon Romanovsky:
>> On Wed, Apr 26, 2017 at 11:22:42AM +0200, Benjamin Drung wrote:
>>> Am Dienstag, den 25.04.2017, 21:04 +0300 schrieb Leon Romanovsky:
>>>> On Mon, Apr 24, 2017 at 03:28:30PM +0200, Benjamin Drung wrote:
>>>>> Hi,
>>>>>
>>>>> the rdmacm-utils binaries cmtime and udpong do not have a
>>>>> corresponding
>>>>>  man page. Please add some since Debian recommends to ship man
>>>>> pages
>>>>> for all binaries.
>>>>
>>>> Is it requirement or recommendation?
>>>
>>> I looked it up. It's considered a bug. The Debian policy says in
>>> §12.1:
>>
>> I understand, I just don't see many volunteers :( to write it.
> 
> Normally the authors of the program are in the best position to write
> such a man page instead of the people from the distributions.

There is now PR #124 in rdma-core github to resolve this. I've asked
Sean to review as he is the author of those examples.

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
