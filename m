From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: list corruption in IPOIB
Date: Mon, 20 May 2013 15:51:44 +0300
Message-ID: <519A1C60.4060005@mellanox.com>
References: <519686B4.7010300@profitbricks.com> <CAJZOPZJNA7E005x9+XdVMG31fLEZm2mKB1nkpt5m3hA1qh7fYg@mail.gmail.com> <5197F447.5020702@profitbricks.com> <51986A8B.9030806@mellanox.com> <519898B0.1000901@profitbricks.com> <5199E747.3070502@mellanox.com> <CAMGffEn6YwXSB7KDfDRJrJmBaiQEG-zAjEonY=JUxMo=nLRSXQ@mail.gmail.com> <519A01DD.6080906@mellanox.com> <CAMGffEk=PJge4jtdcx8xOKA_3RhcSn9wweULxCE7yctPApSn1g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAMGffEk=PJge4jtdcx8xOKA_3RhcSn9wweULxCE7yctPApSn1g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jinpu Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dongsu Park <dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 20/05/2013 15:46, Jinpu Wang wrote:
> A quick test show the list_corruption warning is gone, after I convert
>   all list_del(&neigh->list) to  list_del_list(&neigh->list).

yes, but this wasn't your original problem or was it?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
