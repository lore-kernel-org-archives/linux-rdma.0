From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: list corruption in IPOIB
Date: Mon, 20 May 2013 13:58:37 +0300
Message-ID: <519A01DD.6080906@mellanox.com>
References: <519686B4.7010300@profitbricks.com> <CAJZOPZJNA7E005x9+XdVMG31fLEZm2mKB1nkpt5m3hA1qh7fYg@mail.gmail.com> <5197F447.5020702@profitbricks.com> <51986A8B.9030806@mellanox.com> <519898B0.1000901@profitbricks.com> <5199E747.3070502@mellanox.com> <CAMGffEn6YwXSB7KDfDRJrJmBaiQEG-zAjEonY=JUxMo=nLRSXQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAMGffEn6YwXSB7KDfDRJrJmBaiQEG-zAjEonY=JUxMo=nLRSXQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jinpu Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dongsu Park <dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 20/05/2013 12:10, Jinpu Wang wrote:
> which list_del do you mean? in ipoib_cm_tx_start?
yes, but not only, you can start with 5KG hammer and convert all 
thesehits to list_del_init

linux-2.6]# grep list_del drivers/infiniband/ulp/ipoib/*.c | grep neigh
drivers/infiniband/ulp/ipoib/ipoib_cm.c: list_del(&neigh->list);
drivers/infiniband/ulp/ipoib/ipoib_cm.c: list_del(&neigh->list);
drivers/infiniband/ulp/ipoib/ipoib_cm.c: list_del(&neigh->list);
drivers/infiniband/ulp/ipoib/ipoib_main.c: list_del(&neigh->list);
drivers/infiniband/ulp/ipoib/ipoib_main.c: list_del(&neigh->list);
drivers/infiniband/ulp/ipoib/ipoib_main.c: list_del(&neigh->list);
drivers/infiniband/ulp/ipoib/ipoib_main.c: list_del(&neigh->list);
drivers/infiniband/ulp/ipoib/ipoib_main.c: list_del(&neigh->list);
drivers/infiniband/ulp/ipoib/ipoib_main.c: list_del(&neigh->list);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
