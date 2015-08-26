From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 2/2] IB/ipoib: Suppress warning for send only join failures
Date: Wed, 26 Aug 2015 05:41:08 -0400
Message-ID: <55DD89B4.7070502@dev.mellanox.co.il>
References: <1440200053-18890-1-git-send-email-jgunthorpe@obsidianresearch.com> <1440200053-18890-2-git-send-email-jgunthorpe@obsidianresearch.com> <55DC66A1.9040207@dev.mellanox.co.il> <20150825162856.GC4425@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150825162856.GC4425-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 8/25/2015 12:28 PM, Jason Gunthorpe wrote:
> On Tue, Aug 25, 2015 at 08:59:13AM -0400, Hal Rosenstock wrote:
>>> -		if (mcast->logcount++ < 20) {
>>> -			if (status == -ETIMEDOUT || status == -EAGAIN) {
>>> +		bool silent_fail =
>>> +		    test_bit(IPOIB_MCAST_FLAG_SENDONLY, &mcast->flags) &&
>>> +		    status == -EINVAL;
>>
>> Aren't there other reasons that send only join might have EINVAL
>> indicated ?
> 
> Not sure, the layers below all eat the detailed error code. Hopefully
> EINVAL isn't re-used.

AFAIR there are a number of reasons EINVAL could occur here in which
case this makes this change overly silent. If so, this particular
failure case of send only join failure due to SM rejection (perhaps
ERR_REQ_INVALID SA status only) is best to be made unique and different
from the other current EINVAL failures here.

> 
>> Maybe it's better to be overly silent rather than overly
>> verbose as to not spam the log but it seems like it would make debug of
>> such cases harder.
> 
> It makes debugging harder to have worthless messages because they
> obscure what is going on. The first time I saw this I assumed there
> was an issue, but it turns out to be an expected failure.
> 
> The other issue is the way the rate limiting works:
> 
>>> +		if (mcast->logcount < 20) {
>>> +			if (status == -ETIMEDOUT || status == -EAGAIN ||
>>> +			    silent_fail) {
>>>  				ipoib_dbg_mcast(priv, "%smulticast join failed for %pI6, status %d\n",
>>>  						test_bit(IPOIB_MCAST_FLAG_SENDONLY, &mcast->flags) ? "sendonly " : "",
>>>  						mcast->mcmember.mgid.raw, status);
> 
> So wasting logcount with expected failures just results in eating
> unexpected failures...

Yes, the problem is distinguishing an "expected" failure from the real
ones and only logging the real ones.

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
