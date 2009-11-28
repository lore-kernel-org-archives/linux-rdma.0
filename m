From: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] opensm/osm_db_files.c: add '/' path delimited
Date: Sat, 28 Nov 2009 12:16:06 -0800
Message-ID: <3F6F638B8D880340AB536D29CD4C1E1912CC7DAF28@orsmsx501.amr.corp.intel.com>
References: <784A3771E5D143179461A7D5151AE78C@amr.corp.intel.com>
	 <20091012215455.GK13830@me>
	 <3F6F638B8D880340AB536D29CD4C1E1912C896BBDA@orsmsx501.amr.corp.intel.com>
	 <20091128142342.GA16607@me> <20091128142626.GB16607@me>
	 <3F6F638B8D880340AB536D29CD4C1E1912CC7DAF13@orsmsx501.amr.corp.intel.com>
 <e2e108260911280936w27de9761r7a8818184f184535@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <e2e108260911280936w27de9761r7a8818184f184535-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Bart Van Assche wrote:
> On Sat, Nov 28, 2009 at 5:35 PM, Smith, Stan <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> wrote:
>>
>> Sasha Khapyorsky wrote:
>>> Add '/' path delimiter unconditionally on file path generation.
>>
>> Any chance you could make the path delimiter a #define so there is
>> not an explicit Linux filesystem assumption?
>
> As far as I know the Windows kernel recognizes both forward and
> backward slashes as a path separator.
>
> Bart.

Who would of thought...windows _open() & fopen() can now tolerate a mix-n-match of path delimiters; Implementations do change.

Sasha, skip the #define thought.

Thanks Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
