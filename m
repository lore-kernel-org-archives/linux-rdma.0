From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] infiniband-diags/ibportstate: allow changes to CA
	portinfo parameters
Date: Wed, 13 Jan 2010 15:16:45 -0500
Message-ID: <f0e08f231001131216r65fda740h91ea9ee59dbbc5f8@mail.gmail.com>
References: <1257451016.992.173.camel@chromite.mv.qlogic.com>
	 <1263246218.3077.75.camel@chromite.mv.qlogic.com>
	 <20100112101133.GG26089@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100112101133.GG26089@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 12, 2010 at 5:11 AM, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org> wrote:
> Hi Ralph,
>
> On 13:43 Mon 11 Jan     , Ralph Campbell wrote:
>> Its been 2 months since I posted this.
>> What is the current status? Last comment I saw was from Ira
>> saying either add this functionality to ibportstate or
>> rename ibportstate but don't split it off into a new command.
>
> You are right, it seems that an idea about universal and potentially
> extendable new tool didn't find many fans :)
>
>> My preference is to go with the original patch. I haven't
>> seen any strong objection to it.

I understand Ralph's use case motivating this but it is also a
potentially dangerous tool in the wrong person's hands.

-- Hal

>
> I will go over original patch.
>
> Sasha
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
