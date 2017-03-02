From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 20/20] IB/core: If the MGID/MLID pair is not on the list
 return an error
Date: Thu, 2 Mar 2017 10:01:25 -0500
Message-ID: <4d49f7ab-5bc5-029c-4321-fd349c9dc0f8@intel.com>
References: <20170301181719.29989.31238.stgit@scvm10.sc.intel.com>
 <20170301182426.29989.77369.stgit@scvm10.sc.intel.com>
 <20170302140028.GE9525@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170302140028.GE9525-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 03/02/2017 09:00 AM, Leon Romanovsky wrote:
> On Wed, Mar 01, 2017 at 10:24:32AM -0800, Dennis Dalessandro wrote:
>> From: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>
>> A list of MGID/MLID pairs is built when doing a multicast attach.  When
>> the multicast detach is called, the list is searched, and regardless of
>> the search outcome, the driver detach is called.
>>
>> If an MGID/MLID pair is not on the list, driver detach should not be
>> called, and an error should be returned.  Failure to do so can leave
>> the Multicast list out of sync with what the driver has.
>
> It took me a while to understand your last sentence.
> Can we add Fixes line and submit it to stable too?
>
> Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>

We'll reword the last bit there and add the fixes line and Cc stable.

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
