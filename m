From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH 0/1] Request for Comments on SoftiWarp
Date: Thu, 5 Oct 2017 12:56:15 -0500
Message-ID: <c948ef76-8007-7fa4-8899-c3cbbafead86@opengridcomputing.com>
References: <20171005132659.25930-1-bmt@zurich.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171005132659.25930-1-bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10/5/2017 8:26 AM, Bernard Metzler wrote:
> This patch set introduces the SoftiWarp driver.

Hey Bernard,  Thanks for submitting this!

> >From Friday night on, I will be on vacation for two weeks with only
> limited access to email. I will try to stay connected, and hope for a lively
> discussion. I will of course address all comments latest when I am back on
> October 24th, but I wanted to get the code out now - to get more eyes
> on it.

I think it would be better to submit this as a series of smaller 
patches, perhaps broken up by the siw architecture (verbs handling, 
connection management,  configuration, etc), with the last patch being 
the Makefile/kbuild change to add it.  Then folks can review it more 
easily.

Can you resubmit before you disappear? :)

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
