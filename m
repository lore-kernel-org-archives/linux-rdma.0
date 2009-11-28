From: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] remove unnecessary leading '/' from filename
Date: Sat, 28 Nov 2009 08:30:46 -0800
Message-ID: <3F6F638B8D880340AB536D29CD4C1E1912CC7DAF12@orsmsx501.amr.corp.intel.com>
References: <784A3771E5D143179461A7D5151AE78C@amr.corp.intel.com>
 <20091012215455.GK13830@me>
 <3F6F638B8D880340AB536D29CD4C1E1912C896BBDA@orsmsx501.amr.corp.intel.com>
 <20091128142342.GA16607@me>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091128142342.GA16607@me>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, 'linux-rdma' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sasha Khapyorsky wrote:
> Hi Stan,
>
> On 15:18 Mon 12 Oct     , Smith, Stan wrote:
>>
>> I believe removing the starting '/' from guid2lid filename is the
>> correct fix for a couple of reasons: 1) prefixing a / to a filename
>> seems strange when the path name is spec'ed as having a trailing / ?
>
> I agree. We need to care about making path properly rather than
> introduce a restrictions for directory names definitions.
>
> Sasha

Hello,
  OK on proper paths.
What about the excellent point you raised in previous discussions about those pathnames which are input from environment vars which could be improperly formed? For badly formed paths from ENV vars (lacking trailing '/'), is it sufficient to let open() fail and output path/filename to osm log file?

Stan.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
