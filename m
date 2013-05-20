From: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: list corruption in IPOIB
Date: Mon, 20 May 2013 16:36:41 +0200
Message-ID: <519A34F9.3080700@profitbricks.com>
References: <519686B4.7010300@profitbricks.com> <CAJZOPZJNA7E005x9+XdVMG31fLEZm2mKB1nkpt5m3hA1qh7fYg@mail.gmail.com> <5197F447.5020702@profitbricks.com> <51986A8B.9030806@mellanox.com> <519898B0.1000901@profitbricks.com> <5199E747.3070502@mellanox.com> <CAMGffEn6YwXSB7KDfDRJrJmBaiQEG-zAjEonY=JUxMo=nLRSXQ@mail.gmail.com> <519A01DD.6080906@mellanox.com> <CAMGffEk=PJge4jtdcx8xOKA_3RhcSn9wweULxCE7yctPApSn1g@mail.gmail.com> <519A1C60.4060005@mellanox.com> <CAD+HZHUKU3qq_WbaoW8NfwkoMQWQKeVS1GTGXxBRUEJOridEyg@mail.gmail.com> <519A275B.9070400@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <519A275B.9070400-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Jack Wang <xjtuwjp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dongsu Park <dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 
> Hi Jack,
> 
> I don't understand what is the current status, that is what do you see
> now after applying the patches.
> If you don't get the original bug why did you gave the trace of it? Or
> is it a new trace? It is not clear from your mail.
> Please add only the trace of the current issue.
> 
> Best regards,
> 
> S.P.

Hi Shlomo,

Sorry for confusion.
Current list corruption is gone in my preliminary test, after I changed
list_del to list_del_init as Or suggested.

As Or asked for the original bug, so I just want to show him the whole
story.

Regards,
Jack


> 
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
