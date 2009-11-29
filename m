From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] remove unnecessary leading '/' from filename
Date: Sun, 29 Nov 2009 14:49:01 +0200
Message-ID: <20091129124901.GF16607@me>
References: <784A3771E5D143179461A7D5151AE78C@amr.corp.intel.com>
 <20091012215455.GK13830@me>
 <3F6F638B8D880340AB536D29CD4C1E1912C896BBDA@orsmsx501.amr.corp.intel.com>
 <20091128142342.GA16607@me>
 <3F6F638B8D880340AB536D29CD4C1E1912CC7DAF12@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3F6F638B8D880340AB536D29CD4C1E1912CC7DAF12-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, 'linux-rdma' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 08:30 Sat 28 Nov     , Smith, Stan wrote:
> What about the excellent point you raised in previous discussions about those pathnames which are input from environment vars which could be improperly formed? For badly formed paths from ENV vars (lacking trailing '/'), is it sufficient to let open() fail and output path/filename to osm log file?

We are adding delimiter now (in a file path building code), so it is
not mandatory to have trailing '/' in directory name environment
variable.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
