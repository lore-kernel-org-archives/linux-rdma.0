From: Konstantin Boyanov <konstantin.boyanov-T5F83Mi6MZE@public.gmane.org>
Subject: Re: Segmentation Fault when accessing QPN of a RC Queue pair
Date: Mon, 28 Mar 2011 13:22:14 +0200
Message-ID: <4D906F66.8050107@desy.de>
References: <4D89EDC4.4050309@desy.de>	<CF9C39F99A89134C9CF9C4CCB68B8DDF25DC282B5C@orsmsx501.amr.corp.intel.com> <AANLkTi=ppeQSxHTA18pFM6=y06Q_eNGsY8Fn=gXtXaBM@mail.gmail.com> <4D906993.7030404@desy.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D906993.7030404-T5F83Mi6MZE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Konstantin Boyanov <kkboyanov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello again,

Another thing came to my mind right now - can it be that I get the 
errors described above just because I am using this static functions for 
setting up QPs and the like?  I mean pass to these utility functions the 
pointers to the context data structures and I am not sure wheather or 
not these are handled correctly after return to the main function. Possible?

Regards,
Konstantin
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
