From: Jack Wang <xjtuwjp@gmail.com>
Subject: Re: [PATCH v2 2/8] IB/core: Replace semaphore sm_sem with completion
Date: Tue, 25 Oct 2016 14:43:15 +0200
Message-ID: <CAD+HZHXQE=VptiyLfSdw4MsZR=bjEj_XAB19_=YdjzPY96EK_g@mail.gmail.com>
References: <1477396919-27669-1-git-send-email-binoy.jayan@linaro.org> <1477396919-27669-3-git-send-email-binoy.jayan@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1477396919-27669-3-git-send-email-binoy.jayan@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Binoy Jayan <binoy.jayan@linaro.org>
Cc: Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Arnd Bergmann <arnd@arndb.de>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Hi Binoy,

snip
>
>         port->ib_dev   = device;
>         port->port_num = port_num;
> -       sema_init(&port->sm_sem, 1);
> +       init_completion(&port->sm_comp);
> +       complete(&port->sm_comp);

Why complete here?

>         mutex_init(&port->file_mutex);
>         INIT_LIST_HEAD(&port->file_list);
>
> --
KR,
Jinpu
