From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next v3-v6] Add OPA extended LID support
Date: Fri, 18 Aug 2017 12:09:32 -0400
Message-ID: <ab9a52c8-dd26-0567-de03-b74899c67a63@intel.com>
References: <1502734663-44224-1-git-send-email-don.hiatt@intel.com>
 <50ff7793-413a-09a6-1805-ca0bce0452a2@intel.com>
 <cd6cd877-659d-8218-abf8-a23905af4f42@intel.com>
 <8d3d0a5a-df5e-b023-ec7c-f83e47a22f00@intel.com>
 <20170816060759.GE24282@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170816060759.GE24282-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 8/16/2017 2:07 AM, Leon Romanovsky wrote:
> So the bottom-line, please don't expect from us to do your homework and
> filter the warnings.

No one expects that.

> Before the LIDs patches, the RDMA tree had less than 100 smatch warnings,
> after the LIDs patches, we have more than 200 such warnings.

I will update our internal process and ensure that the static checkers 
get run on any code that is touched, not just what we normally test.

-Denny

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
